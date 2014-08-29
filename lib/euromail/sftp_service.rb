require 'net/sftp'

module Euromail
  class SFTPService

    attr_reader :application, :customer, :host, :username, :password, :current_mode

    def initialize application, customer, host, username, password
      @application = application
      @customer = customer
      @host = host
      @username = username
      @password = password
      @current_mode = :production
    end

    def test_mode!
      self.extend(Euromail::SFTPTest::ServiceMethods)
      @current_mode = :test
    end

    def development_mode!
      self.extend(Euromail::SFTPDevelopment::ServiceMethods)
      @current_mode = :development
    end

    # Attempt to remove the file for the given identifier. If the upload fails or is aborted,
    # this method attempts to remove the incomplete file from the remote server.
    def upload! pdf_data, identifier
      begin
        connect do |connection|
          connection.upload(pdf_data, identifier)
        end
      rescue => e
        remove!(identifier)
        raise e
      end
    end

    # Attempt to remove the file for the given identifier. 
    def remove! identifier
      connect do |connection|
        connection.remove( identifier )
      end
    end

    # Setup a connection to the sftp server. Operations can be defined in the block passed to this method:
    # euromail.connect do |connection|
    #   connection.upload('some data', '1')
    #   connection.upload('more data', '2')
    #   connection.remove('3')
    # end
    def connect &block
      Net::SFTP.start(host, username, :password => password) do |sftp|
        connection = Euromail::SFTPConnection.new(self, sftp)
        block.call(connection)
      end
    end

    # Generate a filename based on the application, customer and some unique identifier.
    # The identifier is not allowed to be blank since this risks previous files from being deleted.
    def filename identifier
      raise "An identifier is required" if identifier.to_s == ''
      "./#{application}_#{customer}_#{identifier}.pdf"
    end

  end
end