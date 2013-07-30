module Euromail
  module SFTPTest

    class SFTPConnection < Euromail::SFTPConnection
      def upload pdf_data, identifier
        @service.uploaded_files = [] if @service.uploaded_files.empty?
        @service.uploaded_files << @service.filename(identifier)
      end

      def remove identifier
        @service.removed_files = [] if @service.removed_files.empty?
        @service.removed_files << @service.filename(identifier)
      end
    end

    module ServiceMethods
      attr_writer :uploaded_files, :removed_files

      def uploaded_files
        return @uploaded_files || []
      end

      def removed_files
        return @removed_files || []
      end

      def connect &block
        connection = Euromail::SFTPTest::SFTPConnection.new(self, "SFTP dummy")
        block.call(connection)
      end
    end

  end
end