require 'spec_helper'

def mock_sftp
  @net_sftp_session = double("Net::SFTP::Session")
  @file_hander = double("SomeFileHandler")

  @file_hander.stub(:write) do |data|
  end

  @net_sftp_session.stub(:remove) do |filename|
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
    Euromail::SFTPService.new('some-cheapass-domain.com', "stefan", "super_secret")
  end

  context "when creating" do
    it "has a host, username and password" do
      service.host.should eql('some-cheapass-domain.com')
      service.username.should eql('stefan')
      service.password.should eql('super_secret')
    end
  end

  describe "upload!" do

    it "connects to euromail using the given username and pass" do
      Net::SFTP.should receive(:start).with('some-cheapass-domain.com', 'stefan', :password => 'super_secret')
      service.upload!('some-client-code', 'letter.pdf')
    end

    it "use the given filename" do
      @net_sftp_session.file.should receive(:open!).with('letter.pdf', 'w')
      service.upload!('some-client-code', 'letter.pdf')
    end

    it "uploads pdf data" do
      @file_hander.should receive(:write).with('some-client-code')
      service.upload!('some-client-code', 'letter.pdf')
    end

    it "first deletes an existing file" do
      @net_sftp_session.should receive(:remove).with('letter.pdf').ordered
      @net_sftp_session.file.should receive(:open!).with('letter.pdf', 'w').ordered
      service.upload!('some-client-code', 'letter.pdf')
    end
  end

end
