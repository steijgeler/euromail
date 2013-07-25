require 'spec_helper'

def mock_sftp
  @net_sftp_session = double("Net::SFTP::Session")
  @file_hander = double("SomeFileHandler")

  @file_hander.stub(:write) do |data|
  end

  @net_sftp_session.stub(:remove!) do |filename|
  end

  @net_sftp_session.stub_chain(:file, :open!) do |filename, method, &block|
    block.call(@file_hander) if block
  end

  Net::SFTP.stub(:start) do |host, username, password_hash, &block|
    block.call(@net_sftp_session) if block
  end
end


describe Euromail::SFTPService do
  before(:each) do
    mock_sftp
  end

  let(:service) do
    Euromail::SFTPService.new('moves', 'nedap', 'some-cheapass-domain.com', "stefan", "super_secret")
  end

  context "when creating" do
    it "has a host, username and password" do
      service.application.should eql('moves')
      service.customer.should eql('nedap')
      service.host.should eql('some-cheapass-domain.com')
      service.username.should eql('stefan')
      service.password.should eql('super_secret')
    end
  end

  describe "upload!" do
    it "connects to euromail using the given username and pass" do
      Net::SFTP.should receive(:start).with('some-cheapass-domain.com', 'stefan', :password => 'super_secret')
      service.upload!('some-client-code', '1')
    end

    it "use the generated filename" do
      @net_sftp_session.file.should receive(:open!).with( service.filename('1'), 'w')
      service.upload!('some-client-code', '1')
    end

    it "uploads pdf data" do
      @file_hander.should receive(:write).with('some-client-code')
      service.upload!('some-client-code', '1')
    end

    it "first removes an existing file" do
      filename = service.filename('1')
      @net_sftp_session.should receive(:remove!).with(filename).ordered
      @net_sftp_session.file.should receive(:open!).with(filename, 'w').ordered
      service.upload!('some-client-code', '1')
    end
  end

  describe "remove!" do
    it "connects to euromail using the given username and pass" do
      Net::SFTP.should receive(:start).with('some-cheapass-domain.com', 'stefan', :password => 'super_secret')
      service.remove!('2')
    end

    it "removes the file from the sftp server" do
      @net_sftp_session.should receive(:remove!).with( service.filename('2') )
      @net_sftp_session.file.should_not receive(:open!)
      service.remove!('2')
    end
  end

  describe "filename" do 
    it "generates a string with application, customer and the given identifier" do
      service.filename('123').should eql('moves_nedap_123.pdf')
    end

    it "requires a non empty identifier" do
      expect{ service.filename('') }.to raise_error
      expect{ service.filename(nil) }.to raise_error
    end
  end

end
