require 'spec_helper'

describe Euromail::SFTPService do
  include SFTPMock

  before(:each) do
    mock_sftp
  end

  let(:euromail) do
    Euromail::SFTPService.new('moves', 'nedap', 'some-cheapass-domain.com', "stefan", "super_secret")
  end

  context "#development_mode!" do
    before(:each) do
      euromail.development_mode!
    end

    it "the current mode is development" do
      expect(euromail.current_mode).to eql :development
    end

    describe "#upload" do
      it "does not upload anything" do
        expect(@file_hander).not_to receive(:write)
        allow($stdout).to receive(:puts)
        euromail.connect do |connection|
          connection.upload('come-client-code', '3')
        end
      end

      it "logs uploads" do
        expect(Net::SFTP).not_to receive(:start)
        expect($stdout).to receive(:puts).with("Connecting to some-cheapass-domain.com")
        expect($stdout).to receive(:puts).with("Uploaded ./moves_nedap_3.pdf")
        expect($stdout).to receive(:puts).with("Connection to some-cheapass-domain.com closed")
        euromail.connect do |connection|
          connection.upload('come-client-code', '3')
        end
      end
    end

    describe "#remove" do
      it "does not remove anything" do
        expect(@net_sftp_session).not_to receive(:remove!)
        allow($stdout).to receive(:puts)
        euromail.connect do |connection|
          connection.remove('3')
        end
      end

      it "logs deletes" do
        expect(Net::SFTP).not_to receive(:start)
        expect($stdout).to receive(:puts).with("Connecting to some-cheapass-domain.com")
        expect($stdout).to receive(:puts).with("Removed ./moves_nedap_3.pdf")
        expect($stdout).to receive(:puts).with("Connection to some-cheapass-domain.com closed")
        euromail.connect do |connection|
          connection.remove('3')
        end
      end
    end

    describe "#connect" do
      it "logs the connection" do
        expect(Net::SFTP).not_to receive(:start)
        expect($stdout).to receive(:puts).with("Connecting to some-cheapass-domain.com")
        expect($stdout).to receive(:puts).with("Connection to some-cheapass-domain.com closed")
        euromail.connect {}
      end
    end

  end

end
