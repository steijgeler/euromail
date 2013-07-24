module Euromail

  class SFTPService

    attr_reader :host, :username, :password

    def initialize host, username, password
      @host = host
      @username = username
      @password = password
    end

  end

end