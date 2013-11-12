require_relative 'system'
require 'mkmf'

module RtMidi
  module Build
    class Compiler
      include RtMidi::Build::System

      attr_reader :compiler_type, :predefines, :system_libs

      def initialize(ext_dir, rtdmidi_dir, options={})
        @ext_dir = ext_dir
        @rtmidi_dir = rtdmidi_dir
        @suppress_output = options.fetch(:suppress_output, false)

        # Set the compiler type
        if platform == :windows and find_executable 'cl.exe'
          @compiler_type = :cl
        else
          if find_executable 'gcc' and find_executable 'g++'
            @compiler_type = :gcc
          else
            abort "Cannot find gcc/g++#{'or cl.exe ' if windows?} compiler"
          end
        end

        # Set the predefines and system_libs
        case platform
          when :osx
            @predefines = '__MACOSX_CORE__'
            @system_libs = '-framework CoreMIDI -framework CoreAudio -framework CoreFoundation'

          when :windows
            @predefines = '__WINDOWS_MM__'
            @system_libs = '-lwinmm'

          when :linux then
            defines, libs = '', ''
            {:alsa => '__LINUX_ALSA__', :jack => '__UNIX_JACK__'}.select do |pkg, _|
              system "pkg-config --exists #{pkg}"
            end.each do |pkg, macro|
              defines << "#{macro} "
              libs << `pkg-config --libs #{pkg}`.chomp
            end
            if defines.empty?
              abort 'Neither JACK or ALSA detected using pkg-config. Please install one of them first.'
            end
            @predefines = defines
            @system_libs = libs

          else abort "Unsupported platform #{platform}"
        end
      end

      def gcc?
        @compiler_type == :gcc
      end

      def suppress_output?
        @suppress_output
      end

      def compile_rtmidi
        puts "\nCompiling RtMidi C++ library" unless suppress_output?
        cd @rtmidi_dir
        if gcc?
          run "g++ -O3 -Wall -Iinclude -fPIC -D#{@predefines} -o RtMidi.o -c RtMidi.cpp"
        else
          run "cl /O2 /Iinclude /D#{@predefines} /EHsc /FoRtMidi.obj /c RtMidi.cpp"
        end
      end

      def compile_ruby_rtmidi_wrapper
        puts "\nCompiling Ruby RtMidi wrapper" unless suppress_output?
        cd @ext_dir
        if gcc?
          run "g++ -g -Wall -I#{@rtmidi_dir} -fPIC -o ruby-rtmidi.o -c ruby-rtmidi.cpp"
        else
          run "cl /I#{@rtmidi_dir} /D__RUBY_RTMIDI_DLL__ /EHsc /Foruby-rtmidi.obj /c ruby-rtmidi.cpp"
        end
      end

      def create_shared_library
        puts "\nCreating the RtMidi + wrapper shared library" unless suppress_output?
        cd @ext_dir
        if gcc?
          run "g++ -g -Wall -I#{@rtmidi_dir} -I#{@rtmidi_dir}/include -D#{@predefines} -fPIC -shared -o ruby-rtmidi.so " +
                "ruby-rtmidi.o #{@rtmidi_dir}/RtMidi.o #{@system_libs}"
        else
          run "cl /I#{@rtmidi_dir} /I#{@rtmidi_dir}/include /D#{@predefines} /LD ruby-rtmidi.obj #{@rtmidi_dir}/RtMidi.obj winmm.lib"
        end
      end

      def compile
        compile_rtmidi
        compile_ruby_rtmidi_wrapper
        create_shared_library
        puts "\nCompilation complete" unless suppress_output?
      end

    end
  end
end
