require_relative 'system'

module RtMidi
  module Build
    class Compiler
      include RtMidi::Build::System

      attr_reader :compiler_type, :predefines, :system_libs

      def initialize(ext_dir, rtdmidi_dir, options={})
        @ext_dir = ext_dir
        @rtmidi_dir = rtdmidi_dir

        @options = options

        determine_compiler_type
        determine_predefines_and_system_libs
      end


      def gcc?
        @compiler_type == :gcc
      end

      def verbose?
        @verbose ||= @options.fetch(:verbose, false)
      end


      def compile
        compile_rtmidi
        compile_ruby_rtmidi_wrapper
        create_shared_library
        puts "\nCompilation complete" if verbose?
      end

      def compile_rtmidi
        puts "\nCompiling RtMidi C++ library" if verbose?
        cd @rtmidi_dir
        if gcc?
          run "g++ -O3 -Wall -Iinclude -fPIC -D#{@predefines} -o RtMidi.o -c RtMidi.cpp"
        else
          run "cl /O2 /Iinclude /D#{@predefines} /EHsc /FoRtMidi.obj /c RtMidi.cpp"
        end
      end

      def compile_ruby_rtmidi_wrapper
        puts "\nCompiling Ruby RtMidi wrapper" if verbose?
        cd @ext_dir
        if gcc?
          run "g++ -g -Wall -I#{@rtmidi_dir} -fPIC -o ruby-rtmidi.o -c ruby-rtmidi.cpp"
        else
          run "cl /I#{@rtmidi_dir} /D__RUBY_RTMIDI_DLL__ /EHsc /Foruby-rtmidi.obj /c ruby-rtmidi.cpp"
        end
      end

      def create_shared_library
        puts "\nCreating the RtMidi + wrapper shared library" if verbose?
        cd @ext_dir
        if gcc?
          run "g++ -g -Wall -I#{@rtmidi_dir} -I#{@rtmidi_dir}/include -D#{@predefines} -fPIC -shared -o ruby-rtmidi.so " +
                "ruby-rtmidi.o #{@rtmidi_dir}/RtMidi.o #{@system_libs}"
        else
          run "cl /I#{@rtmidi_dir} /I#{@rtmidi_dir}/include /D#{@predefines} /LD ruby-rtmidi.obj #{@rtmidi_dir}/RtMidi.obj winmm.lib"
        end
      end


      ############################
      private

      def determine_compiler_type
        if windows? and can_run('cl.exe')
          @compiler_type = :cl
        elsif can_run('gcc') and can_run('g++')
          @compiler_type = :gcc
        else
          abort "Cannot find gcc/g++#{' or cl.exe' if windows?} compiler"
        end
      end


      def determine_predefines_and_system_libs
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
              linux_package_exists(pkg)
            end.each do |pkg, macro|
              defines << "#{macro} "
              libs << linux_library(pkg)
            end
            if defines.empty?
              abort 'Neither JACK or ALSA detected using pkg-config. Please install one of them first.'
            end
            @predefines = defines
            @system_libs = libs

          else abort "Unsupported platform #{platform}"
        end
      end
    end
  end
end
