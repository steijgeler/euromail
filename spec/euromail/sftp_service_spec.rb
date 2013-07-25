require 'spec_helper'

def mock_sftp
  @host = nil
  @username = nil
  @password = nil
  @filename = nil
  @method = nil
  @pdf_data = nil

  @net_sftp_session = double("Net::SFTP::Session")
  @file_hander = double

  @file_hander.stub(:puts) do |data|
    @pdf_data = data
  end

  @net_sftp_session.stub_chain(:file, :open!) do |filename, method, &block|
    @filename = filename
    @method = method

    block.call(@file_hander) if block
  end

  Net::SFTP.stub(:start) do |host, username, password_hash, &block|
    @host = host
    @username = username
    @password = password_hash[:password]

    block.call(@net_sftp_session) if block
  end
end


describe Euromail::SFTPService do
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
    before(:each) do
      mock_sftp
      service.upload!('some-client-code', 'letter.pdf')
    end

    it "connects to euromail using the given username and pass" do
      @host.should eql('some-cheapass-domain.com')
      @username.should eql('stefan')
      @password.should eql('super_secret')
    end

    it "use the given filename" do
      @filename.should eql('letter.pdf')
      @method.should eql('w')
    end

    it "uploads pdf data" do
      @pdf_data.should eql('some-client-code')
    end
  end

end
