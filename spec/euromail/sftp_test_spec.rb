require 'spec_helper'

describe Euromail::SFTPService do
  include SFTPMock

  before(:each) do
    mock_sftp
  end

  let(:service) do
    Euromail::SFTPService.new('moves', 'nedap', 'some-cheapass-domain.com', "stefan", "super_secret")
  end

  context "#test_mode!" do
    before(:each) do
      service.test_mode!
    end

    describe "#upload!" do
      it "stores uploaded filenames" do
        service.uploaded_files.should == []
        service.upload!('some-client-code', '1')
        service.uploaded_files.should == [service.filename('1')]
      end
    end

    describe "remove!" do
      it "stores deleted filenames" do
        service.removed_files.should == []
        service.remove!('2')
        service.removed_files.should == [service.filename('2')]
      end
    end

    describe "connect" do
      it "does nothing" do
        Net::SFTP.should_not receive(:start)
        $stdout.should_not receive(:puts)
        service.connect
      end
    end

  end

end
