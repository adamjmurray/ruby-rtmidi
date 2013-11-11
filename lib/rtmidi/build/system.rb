module RtMidi
  module Build
    module System

      HOST_OS = RbConfig::CONFIG['host_os'].downcase
      OS_X = (HOST_OS =~ /darwin/)
      WINDOWS = ((HOST_OS =~ /win/ and HOST_OS !~ /darwin/) or HOST_OS =~ /mingw/)
      LINUX = (HOST_OS =~ /linux/)

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