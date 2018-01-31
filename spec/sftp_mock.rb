module SFTPMock
  def mock_sftp
    @net_sftp_session = double("Net::SFTP::Session")
    @string_io = double("StringIO")

    RSpec::Mocks.configuration.allow_message_expectations_on_nil
    allow(@file_hander).to receive(:write)
    allow(@net_sftp_session).to receive(:remove!)
    allow(@net_sftp_session).to receive(:upload!)
    allow(StringIO).to receive(:new).and_return(@string_io)

    allow(Net::SFTP).to receive(:start) do |host, username, password_hash, &block|
      block.call(@net_sftp_session) if block
    end
  end
end