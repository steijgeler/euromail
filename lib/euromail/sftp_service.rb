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

    def upload! pdf_data, identifier
      begin
        connect do |sftp|
          sftp.file.open( filename(identifier) , "w") do |f|
            f.write pdf_data
          end
        end
      rescue => e
        remove!(identifier)
        raise e
      end
    end

    # Attempt to remove the file for the given identifier. 
    def remove! identifier
      connect do |sftp|
        sftp.remove!( filename(identifier) )
      end
    end
    
    def connect &block
      Net::SFTP.start(host, username, :password => password, &block)
    end

    # Generate a filename based on the application, customer and some unique identifier.
    # The identifier is not allowed to be blank since this risks previous files from being deleted.
    def filename identifier
      raise "An identifier is required" if identifier.to_s == ''
      "./#{application}_#{customer}_#{identifier}.pdf"
    end

  end

end