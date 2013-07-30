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

    describe "#upload" do
      it "does not upload anything" do
        @file_hander.should_not receive(:write)
      end

      it "logs uploads" do
        Net::SFTP.should_not receive(:start)
        $stdout.should receive(:puts).with("Connecting to some-cheapass-domain.com")
        $stdout.should receive(:puts).with("Uploaded ./moves_nedap_3.pdf")
        $stdout.should receive(:puts).with("Connection to some-cheapass-domain.com closed")
        euromail.connect do |connection|
          connection.upload('come-client-code', '3')
        end
      end
    end

    describe "#remove" do
      it "does not remove anything" do
        @net_sftp_session.should_not receive(:remove!)
      end

      it "logs deletes" do
        Net::SFTP.should_not receive(:start)
        $stdout.should receive(:puts).with("Connecting to some-cheapass-domain.com")
        $stdout.should receive(:puts).with("Removed ./moves_nedap_3.pdf")
        $stdout.should receive(:puts).with("Connection to some-cheapass-domain.com closed")
        euromail.connect do |connection|
          connection.remove('3')
        end
      end
    end

    describe "#connect" do
      it "logs the connection" do
        Net::SFTP.should_not receive(:start)
        $stdout.should receive(:puts).with("Connecting to some-cheapass-domain.com")
        $stdout.should receive(:puts).with("Connection to some-cheapass-domain.com closed")
        euromail.connect {}
      end
    end

  end

end
