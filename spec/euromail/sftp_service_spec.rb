require 'spec_helper'

describe Euromail::SFTPService do
  include SFTPMock

  before(:each) do
    mock_sftp
  end

  let(:euromail) do
    Euromail::SFTPService.new('moves', 'nedap', 'some-cheapass-domain.com', "stefan", "super_secret")
  end

  let(:euromail_with_option) do
    Euromail::SFTPService.new('moves', 'nedap', 'some-cheapass-domain.com', "stefan", "super_secret", {
        some_option: "test option"
    })
  end

  context "when creating" do
    it "has an application, customer, host, username and password" do
      expect(euromail.application).to eql('moves')
      expect(euromail.customer).to eql('nedap')
      expect(euromail.host).to eql('some-cheapass-domain.com')
      expect(euromail.username).to eql('stefan')
      expect(euromail.password).to eql('super_secret')
    end

    it "the current mode is production" do
      expect(euromail.current_mode).to eql :production
    end
  end

  describe "#connect" do
    it "connects to euromail using the given username and pass" do
      expect(Net::SFTP).to receive(:start).with('some-cheapass-domain.com', 'stefan', :password => 'super_secret')
      euromail.connect {}
    end

    it "connects using additional net_ssh options passed from the user" do
      expect(Net::SFTP).to receive(:start).with('some-cheapass-domain.com', 'stefan', :password => 'super_secret', :some_option => "test option")
      euromail_with_option.connect {}
    end
  end

  describe "#upload!" do
    it "uploads pdf data" do
      expect(StringIO).to receive(:new).with('some-client-code')
      expect(@net_sftp_session).to receive(:upload!).with(@string_io, euromail.filename('1'))
      euromail.upload!('some-client-code', '1')
    end

    it "does not remove the remote file after an upload succeeds" do
      expect(euromail).not_to receive(:remove!).with('1')
      euromail.upload!('some-client-code', '1')
    end

    it "tries to remove the remote file after an upload fails" do
      expect(@net_sftp_session).to receive(:upload!).and_raise("Connection dropped")
      expect(euromail).to receive(:remove!).with('1')
      expect{ euromail.upload!('some-client-code', '1') }.to raise_error("Connection dropped")
    end

    it "raises if some error occurs" do
      expect(@net_sftp_session).to receive(:upload!).and_raise("Some error")
      expect{ euromail.upload!('some-client-code', '2') }.to raise_error("Some error")
    end
  end

  describe "#remove!" do
    it "removes the file from the sftp server" do
      expect(@net_sftp_session).to receive(:remove!).with( euromail.filename('2') )
      euromail.remove!('2')
    end

    it "raises if some error occurs" do
      expect(@net_sftp_session).to receive(:remove!).and_raise("Some error")
      expect{ euromail.remove!('2') }.to raise_error("Some error")
    end
  end

  describe "#filename" do 
    it "generates a string with application, customer and the given identifier" do
      expect(euromail.filename('123')).to eql('./moves_nedap_123.pdf')
    end

    it "requires a non empty identifier" do
      expect{ euromail.filename('') }.to raise_error("An identifier is required")
      expect{ euromail.filename(nil) }.to raise_error("An identifier is required")
    end
  end

end
