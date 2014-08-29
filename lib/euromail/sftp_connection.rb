module Euromail
  class SFTPConnection

    def initialize service, sftp
      @service = service
      @sftp = sftp
    end

    def upload pdf_data, identifier
      io = StringIO.new(pdf_data)
      @sftp.upload!(io, @service.filename(identifier))
    end

    def remove identifier
      @sftp.remove!( @service.filename(identifier) )
    end

  end
end
