require_relative 'system'

module RtMidi

  # @private
  module Build

    # @private
    class Compiler
      include RtMidi::Build::System

      def initialize(ext_dir, rtdmidi_dir, options={})
        @ext_dir = ext_dir
        @rtmidi_dir = rtdmidi_dir
        @options = options
        configure # also validates the configuration and gives appropriate errors before we start compiling
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
          run "g++ -O3 -Wall -Iinclude -fPIC #{@predefines} -o RtMidi.o -c RtMidi.cpp"
        else
          run "cl /O2 /Iinclude #{@predefines} /EHsc /FoRtMidi.obj /c RtMidi.cpp"
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
          run "g++ -g -Wall -I#{@rtmidi_dir} -I#{@rtmidi_dir}/include #{@predefines} -fPIC -shared -o ruby-rtmidi.so " +
                "ruby-rtmidi.o #{@rtmidi_dir}/RtMidi.o #{@system_libs}"
        else
          run "cl /I#{@rtmidi_dir} /I#{@rtmidi_dir}/include #{@predefines} /LD ruby-rtmidi.obj #{@rtmidi_dir}/RtMidi.obj #{@system_libs}"
        end
      end


      ############################
      private

      def verbose?
        @verbose ||= @options.fetch(:verbose, false)
      end

      def gcc?
        @compiler == :gcc
      end

      def cl?
        @compiler == :cl
      end

      def jack?
        @api == :jack
      end

      def alsa?
        @api == :alsa
      end

      def configure
        configure_compiler
        configure_midi_api
        configure_predefines
        configure_system_libs
      end

      def configure_compiler
        @compiler = case
          when windows? && can_run('cl.exe') then :cl
          when can_run('gcc') && can_run('g++') then :gcc
          else raise "Cannot find gcc/g++#{' or cl.exe' if windows?} compiler"
        end
      end

      def configure_midi_api
        @api = case
          when osx? then :coremidi
          when windows? then :winmm
          when linux?
            case
              when linux_package_exists(:jack) then :jack
              when linux_package_exists(:alsa) then :alsa
              else raise 'Neither JACK or ALSA detected using pkg-config. Please install one of them first.'
            end
          else raise "Unsupported platform #{platform}"
        end
      end

      def configure_predefines
        @predefines = case
          when osx? then '-D__MACOSX_CORE__'
          when windows? && gcc? then '-D__WINDOWS_MM__'
          when windows? && cl? then '/D__WINDOWS_MM__'
          when linux? && jack? then '-D__UNIX_JACK__'
          when linux? && alsa? then '-D__LINUX_ALSA__'
          else raise "Could not set predefines"
        end
      end

      def configure_system_libs
        @system_libs = case
          when osx? then '-framework CoreMIDI -framework CoreAudio -framework CoreFoundation'
          when windows? && gcc? then '-lwinmm'
          when windows? && cl? then 'winmm.lib'
          when linux? then linux_library(@api)
          else raise "Could not set system_libs"
        end
      end
    end
  end
end
