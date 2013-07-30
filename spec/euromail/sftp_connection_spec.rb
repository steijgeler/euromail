 require 'spec_helper'

describe Euromail::SFTPConnection do
  include SFTPMock

  before(:each) do
    mock_sftp
  end

  let(:euromail) do
    Euromail::SFTPService.new('moves', 'nedap', 'some-cheapass-domain.com', "stefan", "super_secret")
  end

  describe "#upload" do
    it "use the generated filename" do
      @net_sftp_session.file.should receive(:open).with( euromail.filename('1'), 'w')
      euromail.connect do |connection|
        connection.upload('some-client-code', '1')
      end
    end

    it "does not reestablish a connection for each upload" do
      expect(Net::SFTP).to receive(:start).once
      euromail.connect do |connection|
        connection.upload('some-client-code', '1')
        connection.upload('another-client-code', '2')
      end
    end

    it "can upload several pdf files within the same connection" do
      expect(@net_sftp_session.file).to receive(:open).exactly(2).times
      @file_hander.should receive(:write).with('some-client-code-1')
      @file_hander.should receive(:write).with('some-client-code-2')

      euromail.connect do |connection|
        connection.upload("some-client-code-1", '1')
        connection.upload("some-client-code-2", '2')
      end
    end
  end

  describe "#remove" do
    it "removes the file with the generated filename" do
      @net_sftp_session.should receive(:remove!).with( euromail.filename('1') )
      euromail.connect do |connection|
        connection.remove('1')
      end
    end

    it "does not reestablish a connection for each remove" do
      expect(Net::SFTP).to receive(:start).once
      euromail.connect do |connection|
        connection.remove('1')
        connection.remove('2')
      end
    end

  end


end
