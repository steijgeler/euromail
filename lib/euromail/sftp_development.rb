module Euromail

  module SFTPDevelopment

    def upload pdf_data, identifier
      raise "Can only be called in a connect block" unless @sftp

      $stdout.puts "Uploaded #{filename(identifier)}"
    end

    def remove identifier
      raise "Can only be called in a connect block" unless @sftp

      $stdout.puts "Removed #{filename(identifier)}"
    end

    def connect &block
      $stdout.puts "Connecting to #{host}"

      @sftp = 'Dummy'
      block.call(self)
      @sftp = nil

      $stdout.puts "Connection to #{host} closed"
    end

  end

end

