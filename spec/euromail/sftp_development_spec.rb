require 'spec_helper'

describe Euromail::SFTPService do
  include SFTPMock

  before(:each) do
    mock_sftp
  end

  let(:service) do
    Euromail::SFTPService.new('moves', 'nedap', 'some-cheapass-domain.com', "stefan", "super_secret")
  end

  context "#development_mode!" do
    before(:each) do
      service.development_mode!
    end

    describe "#upload!" do
      it "only logs uploads" do
        Net::SFTP.should_not receive(:start)
        $stdout.should receive(:puts).with("Connecting to some-cheapass-domain.com")
        $stdout.should receive(:puts).with("Uploaded ./moves_nedap_3.pdf")
        $stdout.should receive(:puts).with("Connection to some-cheapass-domain.com closed")
        service.upload!('come-client-code', '3')
      end
    end

    describe "remove!" do
      it "only logs deletes" do
        Net::SFTP.should_not receive(:start)
        $stdout.should receive(:puts).with("Connecting to some-cheapass-domain.com")
        $stdout.should receive(:puts).with("Removed ./moves_nedap_3.pdf")
        $stdout.should receive(:puts).with("Connection to some-cheapass-domain.com closed")
        service.remove!('3')
      end
    end

    describe "connect" do
      it "only logs the connection" do
        Net::SFTP.should_not receive(:start)
        $stdout.should receive(:puts).with("Connecting to some-cheapass-domain.com")
        $stdout.should receive(:puts).with("Connection to some-cheapass-domain.com closed")
        service.connect
      end
    end

  end

end
