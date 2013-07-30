module Euromail
  module SFTPDevelopment

    class SFTPConnection < Euromail::SFTPConnection
      def upload pdf_data, identifier
        $stdout.puts "Uploaded #{@service.filename(identifier)}"
      end

      def remove identifier
        $stdout.puts "Removed #{@service.filename(identifier)}"
      end
    end

    module ServiceMethods
      def connect &block
        $stdout.puts "Connecting to #{host}"

        connection = Euromail::SFTPDevelopment::SFTPConnection.new(self, "SFTP dummy")
        block.call(connection)

        $stdout.puts "Connection to #{host} closed"
      end
    end

  end
end

