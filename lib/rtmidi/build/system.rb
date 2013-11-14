require 'mkmf'

module RtMidi

  # @private
  module Build

    # @private
    module System

      def platform
        case RbConfig::CONFIG['host_os'].downcase
          when /darwin/ then :osx  # check this first since the next case would match darwin for :windows
          when /(win)|(mingw)/ then :windows
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

      def can_run(cmd)
        find_executable(cmd)
      end

      def run(cmd)
        puts cmd
        unless system(cmd)
          puts "Error: command exited with return value #{$?.exitstatus}"
          exit $?.exitstatus
        end
      end

      def linux_package_exists(pkg)
        system "pkg-config --exists #{pkg}"
      end

      def linux_library(pkg)
        `pkg-config --libs #{pkg}`.chomp
      end

    end
  end
end