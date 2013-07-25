module SFTPMock
  def mock_sftp
    @net_sftp_session = double("Net::SFTP::Session")
    @file_hander = double("SomeFileHandler")

    @file_hander.stub(:write) do |data|
    end

    @net_sftp_session.stub(:remove!) do |filename|
    end

    @net_sftp_session.stub_chain(:file, :open!) do |filename, method, &block|
      block.call(@file_hander) if block
    end

    Net::SFTP.stub(:start) do |host, username, password_hash, &block|
      block.call(@net_sftp_session) if block
    end
  end
end