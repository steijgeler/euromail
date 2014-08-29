module SFTPMock
  def mock_sftp
    @net_sftp_session = double("Net::SFTP::Session")
    @string_io = double("StringIO")

    @file_hander.stub(:write) do |data|
    end

    @net_sftp_session.stub(:remove!) do |filename|
    end

    @net_sftp_session.stub(:upload!) do |filename|
    end

    StringIO.stub(:new).and_return(@string_io)

    Net::SFTP.stub(:start) do |host, username, password_hash, &block|
      block.call(@net_sftp_session) if block
    end
  end
end