module Euromail

  module SFTPDevelopment

    def upload! pdf_data, identifier
      connect do 
        $stdout.puts "Uploaded #{filename(identifier)}"
      end
    end

    def remove! identifier
      connect do
        $stdout.puts "Removed #{filename(identifier)}"
      end
    end

    def connect &block
      $stdout.puts "Connecting to #{host}"
      block.call if block
      $stdout.puts "Connection to #{host} closed"
    end

  end

end

