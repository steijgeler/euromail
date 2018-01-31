require 'spec_helper'

describe Euromail::SFTPService do
  include SFTPMock

  before(:each) do
    mock_sftp
  end

  let(:euromail) do
    Euromail::SFTPService.new('moves', 'nedap', 'some-cheapass-domain.com', "stefan", "super_secret")
  end

  context "#test_mode!" do
    before(:each) do
      euromail.test_mode!
    end

    it "the current mode is test" do
      expect(euromail.current_mode).to eql :test
    end

    describe "#upload" do
      it "does not upload anything" do
        expect(@file_hander).not_to receive(:write)
        euromail.upload!('some-client-code', '1')
      end
      
      it "stores uploaded filenames" do
        expect(euromail.uploaded_files).to eql([])
        euromail.upload!('some-client-code', '1')
        expect(euromail.uploaded_files).to eql([euromail.filename('1')])
      end
    end

    describe "#remove" do
      it "does not remove anything" do
        expect(@net_sftp_session).not_to receive(:remove!)
        euromail.remove!('2')
      end

      it "stores deleted filenames" do
        expect(euromail.removed_files).to eql([])
        euromail.remove!('2')
        expect(euromail.removed_files).to eql([euromail.filename('2')])
      end
    end

    describe "#connect" do
      it "only calls the block" do
        expect(Net::SFTP).not_to receive(:start)
        expect($stdout).not_to receive(:puts)
        euromail.connect {}
      end
    end

  end

end
