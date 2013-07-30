module Euromail
  class SFTPConnection

    def initialize service, sftp
      @service = service
      @sftp = sftp
    end

    def upload pdf_data, identifier
      @sftp.file.open( @service.filename(identifier) , "w") do |f|
        f.write pdf_data
      end      
    end

    def remove identifier
      @sftp.remove!( @service.filename(identifier) )
    end

  end
end
