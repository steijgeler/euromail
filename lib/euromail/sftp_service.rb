require 'net/sftp'

module Euromail

  class SFTPService

    attr_reader :host, :username, :password

    def initialize host, username, password
      @host = host
      @username = username
      @password = password
    end

    def upload! pdf_data, filename
      Net::SFTP.start(host, username, :password => password) do |sftp|
        sftp.remove(filename)
        sftp.file.open!(filename, "w") do |f|
          f.write pdf_data
        end
      end
    end

  end

end