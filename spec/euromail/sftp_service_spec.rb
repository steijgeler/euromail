require 'spec_helper'

describe Euromail::SFTPService do
  include SFTPMock

  before(:each) do
    mock_sftp
  end

  let(:euromail) do
    Euromail::SFTPService.new('moves', 'nedap', 'some-cheapass-domain.com', "stefan", "super_secret")
  end

  context "when creating" do
    it "has an application, customer, host, username and password" do
      euromail.application.should eql('moves')
      euromail.customer.should eql('nedap')
      euromail.host.should eql('some-cheapass-domain.com')
      euromail.username.should eql('stefan')
      euromail.password.should eql('super_secret')
    end
  end

  describe "#connect" do
    it "connects to euromail using the given username and pass" do
      Net::SFTP.should receive(:start).with('some-cheapass-domain.com', 'stefan', :password => 'super_secret')
      euromail.connect {}
    end
  end

  describe "#upload!" do
    it "uploads pdf data" do
      @file_hander.should receive(:write).with('some-client-code')
      euromail.upload!('some-client-code', '1')
    end

    it "does not remove the remote file after an upload succeeds" do
      euromail.should_not receive(:remove!).with('1')
      euromail.upload!('some-client-code', '1')
    end

    it "tries to remove the remote file after an upload fails" do
      @file_hander.stub(:write).and_raise("Connection dropped")
      euromail.should receive(:remove!).with('1')
      expect{ euromail.upload!('some-client-code', '1') }.to raise_error
    end

    it "raises if some error occurs" do
      @net_sftp_session.stub_chain(:file, :open).and_raise("Some error")
      expect{ euromail.upload!('some-client-code', '2') }.to raise_error
    end
  end

  describe "#remove!" do
    it "removes the file from the sftp server" do
      @net_sftp_session.should receive(:remove!).with( euromail.filename('2') )
      @net_sftp_session.file.should_not receive(:open)
      euromail.remove!('2')
    end

    it "raises if some error occurs" do
      @net_sftp_session.stub(:remove!).and_raise("Some error")
      expect{ euromail.remove!('2') }.to raise_error
    end
  end

  describe "#filename" do 
    it "generates a string with application, customer and the given identifier" do
      euromail.filename('123').should eql('./moves_nedap_123.pdf')
    end

    it "requires a non empty identifier" do
      expect{ euromail.filename('') }.to raise_error
      expect{ euromail.filename(nil) }.to raise_error
    end
  end

end
