require 'net/sftp'

module Euromail

  class SFTPService

    attr_reader :application, :customer, :host, :username, :password

    def initialize application, customer, host, username, password
      @application = application
      @customer = customer
      @host = host
      @username = username
      @password = password
    end

    def test_mode!
      self.extend(Euromail::SFTPTest)
    end

    def development_mode!
      self.extend(Euromail::SFTPDevelopment)
    end

    # Upload pdf data to a file on the remote sftp server. Must be called within a connect block:
    # euromail.connect do |service|
    #   service.upload('some-data', '1')
    # end
    def upload pdf_data, identifier
      raise "Can only be called in a connect block" unless @sftp
      @sftp.file.open( filename(identifier) , "w") do |f|
        f.write pdf_data
      end      
    end

    # Attempt to remove the file for the given identifier. If the upload fails or is aborted,
    # this method attempts to remove the incomplete file from the remote server.
    def upload! pdf_data, identifier
      begin
        connect do |service|
          service.upload(pdf_data, identifier)
        end
      rescue => e
        remove!(identifier)
        raise e
      end
    end
    
    # Removes a pdf file on the remote sftp server. Must be called within a connect block:
    # euromail.connect do |service|
    #   service.remove('1')
    # end
    def remove identifier
      raise "Can only be called in a connect block" unless @sftp
      @sftp.remove!( filename(identifier) )
    end

    # Attempt to remove the file for the given identifier. 
    def remove! identifier
      connect do |service|
        service.remove( identifier )
      end
    end

    # Setup a connection to the sftp server. Operations can be defined in the block passed to this method:
    # euromail.connect do |service|
    #   service.upload('some data', '1')
    #   service.upload('more data', '2')
    #   service.remove('3')
    # end
    def connect &block
      Net::SFTP.start(host, username, :password => password) do |sftp|
        begin
          @sftp = sftp
          block.call(self)
        ensure
          @sftp = nil
        end
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