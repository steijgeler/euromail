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

    describe "#upload" do
      it "must be called in a connect block" do
        expect{ euromail.upload('some-client-code', '1')}.to raise_error(RuntimeError)
      end

      it "stores uploaded filenames" do
        euromail.uploaded_files.should == []
        euromail.upload!('some-client-code', '1')
        euromail.uploaded_files.should == [euromail.filename('1')]
      end
    end

    describe "remove" do
      it "must be called in a connect block" do
        expect{ euromail.remove('1')}.to raise_error(RuntimeError)
      end
      
      it "stores deleted filenames" do
        euromail.removed_files.should == []
        euromail.remove!('2')
        euromail.removed_files.should == [euromail.filename('2')]
      end
    end

    describe "connect" do
      it "only calls the block" do
        Net::SFTP.should_not receive(:start)
        $stdout.should_not receive(:puts)
        euromail.connect {}
      end
    end

  end

end
