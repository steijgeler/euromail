module Euromail
  module SFTPTest

    attr_writer :uploaded_files, :removed_files

    def uploaded_files
      return @uploaded_files || []
    end

    def removed_files
      return @removed_files || []
    end

    def upload! pdf_data, identifier
      @uploaded_files = [] if @uploaded_files.nil?
      @uploaded_files << filename(identifier)
    end

    def remove! identifier
      @removed_files = [] if @removed_files.nil?
      @removed_files << filename(identifier)
    end

    def connect &block
    end

  end

end