require_relative 'system'

module RtMidi
  module Build
    class Compiler
      include RtMidi::Build::System

      require "mkmf"
      COMPILER = if WINDOWS and find_executable "cl.exe"
        :cl
      else
        if find_executable "gcc" and find_executable "g++"
          :gcc
        else
          abort "Cannot find gcc/g++ #{'or cl.exe ' if WINDOWS}compiler"
        end
      end

      PREDEFINE, SYSTEM_LIBS = *case
        when OS_X then ["__MACOSX_CORE__", "-framework CoreMIDI -framework CoreAudio -framework CoreFoundation"]
        when WINDOWS then ["__WINDOWS_MM__", "-lwinmm"]
        when LINUX then
          defines, libs = '', ''
          {:alsa => '__LINUX_ALSA__', :jack => '__UNIX_JACK__'}.select do |pkg, _|
            system "pkg-config --exists #{pkg}"
          end.each do |pkg, macro|
            defines << "#{macro} "
            libs << `pkg-config --libs #{pkg}`.chomp
          end
          if defines.empty?
            raise 'Neither JACK or ALSA detected using pkg-config. Please install one of them first.'
          end
          [defines, libs]
        else
      end


      def compile_rtmidi
        cd RTMIDI_DIR
        if COMPILER == :gcc
          run "g++ -O3 -Wall -Iinclude -fPIC -D#{PREDEFINE} -o RtMidi.o -c RtMidi.cpp"
        else
          run "cl /O2 /Iinclude /D#{PREDEFINE} /EHsc /FoRtMidi.obj /c RtMidi.cpp"
        end
      end

      def compile_ruby_rtmidi_wrapper
        cd EXT_DIR
        if COMPILER == :gcc
          run "g++ -g -Wall -I#{RTMIDI_DIR} -fPIC -o ruby-rtmidi.o -c ruby-rtmidi.cpp"
        else
          run "cl /I#{RTMIDI_DIR} /D__RUBY_RTMIDI_DLL__ /EHsc /Foruby-rtmidi.obj /c ruby-rtmidi.cpp"
        end
      end

      def create_shared_library
        cd EXT_DIR
        if COMPILER == :gcc
          run "g++ -g -Wall -I#{RTMIDI_DIR} -I#{RTMIDI_DIR}/include -D#{PREDEFINE} -fPIC -shared -o ruby-rtmidi.so " +
                "ruby-rtmidi.o #{RTMIDI_DIR}/RtMidi.o #{SYSTEM_LIBS}"
        else
          run "cl /I#{RTMIDI_DIR} /I#{RTMIDI_DIR}/include /D#{PREDEFINE} /LD ruby-rtmidi.obj #{RTMIDI_DIR}/RtMidi.obj winmm.lib"
        end
      end

      def self.compile
        c = new
        c.compile_rtmidi
        puts
        c.compile_ruby_rtmidi_wrapper
        puts
        c.create_shared_library
      end

    end
  end
end
