module RtMidi
  module Build
    module System

      def platform
        case RbConfig::CONFIG['host_os'].downcase
          when /darwin/ then :osx
          when ((HOST_OS =~ /win/ and HOST_OS !~ /darwin/) or HOST_OS =~ /mingw/) then :windows
          when /linux/ then :linux
        end
      end

      def osx?
        platform == :osx
      end

      def windows?
        platform == :windows
      end

      def linux?
        platform == :linux
      end

      def cd(dir)
        puts "cd #{dir}"
        Dir.chdir(dir)
      end

      def run(cmd)
        puts cmd
        unless system(cmd)
          puts "Error: command exited with return value #{$?.exitstatus}"
          exit $?.exitstatus
        end
      end

    end
  end
end