require 'spec_helper'

# Stub out the system code and record what was done
class RtMidi::Build::Compiler

  def platform
    @options[:platform]
  end

  def cd(dir)
    @current_dir = dir
  end

  def can_run(cmd)
    # simulate the compiler executables being on the path given a @context set in the tests below
    case @options[:compiler]
      when :gcc then cmd == 'gcc' or cmd == 'g++'
      when :cl then cmd == 'cl.exe'
      when false
    end
  end

  def run(cmd)
    (@commands ||= []) << cmd
  end

  def linux_package_exists(pkg)
    pkg == @options[:library]
  end

  def linux_library(pkg)
    "lib#{@options[:library]}"
  end

  attr_reader :current_dir, :commands

  def command
    @commands.last
  end
end


describe RtMidi::Build::Compiler do

  def compiler_for(platform, compiler, library=nil)
    RtMidi::Build::Compiler.new(ext_dir, rtmidi_dir, platform: platform, compiler: compiler, library: library)
  end

  let(:ext_dir) { '/ext_dir' }
  let(:rtmidi_dir) { '/rtmidi_dir' }

  let(:osx_compiler)         { compiler_for :osx, :gcc }
  let(:windows_gcc_compiler) { compiler_for :windows, :gcc }
  let(:windows_cl_compiler)  { compiler_for :windows, :cl }
  let(:linux_jack_compiler)  { compiler_for :linux, :gcc, :jack }
  let(:linux_alsa_compiler)  { compiler_for :linux, :gcc, :alsa }

  let(:gcc_compilers) { [osx_compiler, windows_gcc_compiler, linux_jack_compiler, linux_alsa_compiler] }
  let(:cl_compiler)   { windows_cl_compiler }
  let(:compilers)     { [osx_compiler, windows_gcc_compiler, windows_cl_compiler, linux_jack_compiler, linux_alsa_compiler] }


  describe '.new' do
    it 'fails for unrecognized platforms' do
      ->{ compiler_for(:commodore64, :gcc) }.should raise_error 'Unsupported platform commodore64'
    end

    context 'on osx' do
      it 'fails if gcc/g++ is not available' do
        ->{ compiler_for(:osx, nil) }.should raise_error 'Cannot find gcc/g++ compiler'
      end
    end

    context 'on linux' do
      it 'fails if gcc/g++ is not available' do
        ->{ compiler_for(:linux, nil) }.should raise_error 'Cannot find gcc/g++ compiler'
      end

      it 'fails if neither JACK or ALSA is available' do
        ->{ compiler_for(:linux, :gcc) }.should raise_error 'Neither JACK or ALSA detected using pkg-config. Please install one of them first.'
      end
    end

    context 'on windows' do
      it 'fails if neither gcc/g++ or cl.exe is available' do
        ->{ compiler_for(:windows, nil) }.should raise_error 'Cannot find gcc/g++ or cl.exe compiler'
      end
    end
  end


  describe '#compile_rtmidi' do

    it 'changes the current director to the rtmidi_dir' do
      for compiler in compilers
        compiler.compile_rtmidi
        compiler.current_dir.should == rtmidi_dir
      end
    end

    it 'runs a single command' do
      for compiler in compilers
        compiler.compile_rtmidi
        compiler.commands.length.should == 1
      end
    end

    context 'with gcc' do
      it 'runs g++' do
        for compiler in gcc_compilers
          compiler.compile_rtmidi
          compiler.command[0..2].should == 'g++'
        end
      end

      it 'includes the subfolder named include' do
        for compiler in gcc_compilers
          compiler.compile_rtmidi
          compiler.command.should =~ /-Iinclude/
        end
      end

      it 'compiles RtMidi.cpp' do
        for compiler in gcc_compilers
          compiler.compile_rtmidi
          compiler.command.should =~ /-c\s+RtMidi\.cpp/
        end
      end

      it 'outputs RtMidi.o' do
        for compiler in gcc_compilers
          compiler.compile_rtmidi
          compiler.command.should =~ /-o\s+RtMidi\.o/
        end
      end

      context 'on osx' do
        it 'predefines __MACOSX_CORE__' do
          osx_compiler.compile_rtmidi
          osx_compiler.command.should =~ /-D__MACOSX_CORE__/
        end
      end

      context 'on windows' do
        it 'predefines __WINDOWS_MM__' do
          windows_gcc_compiler.compile_rtmidi
          windows_gcc_compiler.command.should =~ /-D__WINDOWS_MM__/
        end
      end

      context 'on linux' do
        context 'with ALSA' do
          it 'predefines __LINUX_ALSA__' do
            linux_alsa_compiler.compile_rtmidi
            linux_alsa_compiler.command.should =~ /-D__LINUX_ALSA__/
          end
        end

        context 'with JACK' do
          it 'predefines __UNIX_JACK__' do
            linux_jack_compiler.compile_rtmidi
            linux_jack_compiler.command.should =~ /-D__UNIX_JACK__/
          end
        end
      end
    end

    context 'with cl.exe' do
      it 'runs cl' do
        cl_compiler.compile_rtmidi
        cl_compiler.command[0..1].should == 'cl'
      end

      it 'includes the subfolder named include' do
        cl_compiler.compile_rtmidi
        cl_compiler.command.should =~ /\/Iinclude/
      end

      it 'compiles RtMidi.cpp' do
        cl_compiler.compile_rtmidi
        cl_compiler.command.should =~ /\/c\s+RtMidi\.cpp/
      end

      it 'outputs RtMidi.obj' do
        cl_compiler.compile_rtmidi
        cl_compiler.command.should =~ /\/FoRtMidi.obj/
      end

      it 'predefines __WINDOWS_MM__' do
        cl_compiler.compile_rtmidi
        cl_compiler.command.should =~ /\/D__WINDOWS_MM__/
      end
    end
  end


  describe '#compile_ruby_rtmidi_wrapper' do

    it 'changes the current director to the ext_dir' do
      for compiler in compilers
        compiler.compile_ruby_rtmidi_wrapper
        compiler.current_dir.should == ext_dir
      end
    end

    it 'runs a single command' do
      for compiler in compilers
        compiler.compile_ruby_rtmidi_wrapper
        compiler.commands.length.should == 1
      end
    end

    context 'with gcc' do
      it 'runs g++' do
        for compiler in gcc_compilers
          compiler.compile_ruby_rtmidi_wrapper
          compiler.command[0..2].should == 'g++'
        end
      end

      it 'includes the rtmidi_dir' do
        for compiler in gcc_compilers
          compiler.compile_ruby_rtmidi_wrapper
          compiler.command.should =~ /\s-I#{rtmidi_dir}\b/
        end
      end

      it 'compiles ruby-rtmidi.cpp' do
        for compiler in gcc_compilers
          compiler.compile_ruby_rtmidi_wrapper
          compiler.command.should =~ /\s-c\s+ruby-rtmidi\.cpp\b/
        end
      end

      it 'outputs ruby-rtmidi.o' do
        for compiler in gcc_compilers
          compiler.compile_ruby_rtmidi_wrapper
          compiler.command.should =~ /\s-o\s+ruby-rtmidi\.o\b/
        end
      end
    end

    context 'with cl.exe' do
      it 'runs cl' do
        cl_compiler.compile_ruby_rtmidi_wrapper
        cl_compiler.command[0..1].should == 'cl'
      end

      it 'includes the rtmidi_dir' do
        cl_compiler.compile_ruby_rtmidi_wrapper
        cl_compiler.command.should =~ /\s\/I#{rtmidi_dir}\b/
      end

      it 'compiles ruby-rtmidi.cpp' do
        cl_compiler.compile_ruby_rtmidi_wrapper
        cl_compiler.command.should =~ /\s\/c\s+ruby-rtmidi\.cpp\b/
      end

      it 'outputs ruby-rtmidi.obj' do
        cl_compiler.compile_ruby_rtmidi_wrapper
        cl_compiler.command.should =~ /\s\/Foruby-rtmidi\.obj\b/
      end

      it 'predefines __RUBY_RTMIDI_DLL__' do
        cl_compiler.compile_ruby_rtmidi_wrapper
        cl_compiler.command.should =~ /\s\/D__RUBY_RTMIDI_DLL__\b/
      end
    end
  end


  describe '#create_shared_library' do

    it 'changes the current director to the ext_dir' do
      for compiler in compilers
        compiler.create_shared_library
        compiler.current_dir.should == ext_dir
      end
    end

    it 'runs a single command' do
      for compiler in compilers
        compiler.create_shared_library
        compiler.commands.length.should == 1
      end
    end

    context 'with gcc' do
      it 'runs g++' do
        for compiler in gcc_compilers
          compiler.create_shared_library
          compiler.command[0..2].should == 'g++'
        end
      end

      it 'includes the rtmidi_dir' do
        for compiler in gcc_compilers
          compiler.create_shared_library
          compiler.command.should =~ /\s-I#{rtmidi_dir}\b/
        end
      end

      it 'includes the rtmidi_dir/include folder' do
        for compiler in gcc_compilers
          compiler.create_shared_library
          compiler.command.should =~ /\s-I#{rtmidi_dir}\/include\b/
        end
      end

      it 'creates a shared library' do
        for compiler in gcc_compilers
          compiler.create_shared_library
          compiler.command.should =~ /\s-shared\b/
        end
      end

      it 'uses the output from the previous compilation steps' do
        for compiler in gcc_compilers
          compiler.create_shared_library
          compiler.command.should =~ /\sruby-rtmidi\.o\s+#{rtmidi_dir}\/RtMidi\.o\b/
        end
      end

      it 'outputs ruby-rtmidi.so' do
        for compiler in gcc_compilers
          compiler.create_shared_library
          compiler.command.should =~ /\s-o\s+ruby-rtmidi\.so\b/
        end
      end

      context 'on osx' do
        it 'predefines __MACOSX_CORE__' do
          osx_compiler.create_shared_library
          osx_compiler.command.should =~ /\s-D__MACOSX_CORE__\b/
        end

        it 'includes the system libs: -framework CoreMIDI -framework CoreAudio -framework CoreFoundation' do
          osx_compiler.create_shared_library
          osx_compiler.command.should =~ /\s-framework\s+CoreMIDI\s+-framework\s+CoreAudio\s+-framework\s+CoreFoundation\b/
        end
      end

      context 'on windows' do
        it 'predefines __WINDOWS_MM__' do
          windows_gcc_compiler.create_shared_library
          windows_gcc_compiler.command.should =~ /\s-D__WINDOWS_MM__\b/
        end

        it 'includes the system lib winmm' do
          windows_gcc_compiler.create_shared_library
          windows_gcc_compiler.command.should =~ /\s-lwinmm\b/
        end
      end

      context 'on linux' do
        context 'with ALSA' do
          it 'predefines __LINUX_ALSA__' do
            linux_alsa_compiler.create_shared_library
            linux_alsa_compiler.command.should =~ /\s-D__LINUX_ALSA__\b/
          end

          it 'includes the system lib for alsa' do
            linux_alsa_compiler.create_shared_library
            linux_alsa_compiler.command.should =~ /\slibalsa\b/
          end
        end

        context 'with JACK' do
          it 'predefines __UNIX_JACK__' do
            linux_jack_compiler.create_shared_library
            linux_jack_compiler.command.should =~ /\s-D__UNIX_JACK__\b/
          end

          it 'includes the system lib for jack' do
            linux_jack_compiler.create_shared_library
            linux_jack_compiler.command.should =~ /\slibjack\b/
          end
        end
      end
    end

    context 'with cl.exe' do
      it 'runs cl' do
        cl_compiler.create_shared_library
        cl_compiler.command[0..1].should == 'cl'
      end

      it 'includes the subfolder named include' do
        cl_compiler.create_shared_library
        cl_compiler.command.should =~ /\s\/I#{rtmidi_dir}\b/
      end

      it 'includes the rtmidi_dir/include folder' do
        cl_compiler.create_shared_library
        cl_compiler.command.should =~ /\s\/I#{rtmidi_dir}\/include\b/
      end

      it 'uses the output from the previous compilation steps' do
        cl_compiler.create_shared_library
        cl_compiler.command.should =~ /\sruby-rtmidi\.obj\s+#{rtmidi_dir}\/RtMidi\.obj\b/
      end

      it 'creates a DLL' do
        cl_compiler.create_shared_library
        cl_compiler.command.should =~ /\s\/LD\b/
      end

      it 'predefines __WINDOWS_MM__' do
        cl_compiler.create_shared_library
        cl_compiler.command.should =~ /\s\/D__WINDOWS_MM__\b/
      end

      it 'includes the system lib winmm' do
        cl_compiler.create_shared_library
        cl_compiler.command.should =~ /\bwinmm\.lib\b/
      end
    end
  end


  describe '#compile' do
    it 'runs #compile_rtmidi, #compile_ruby_rtmidi_wrapper, and #create_shared_library' do
      for compiler in compilers
        compiler.compile
        commands = compiler.commands.dup

        compiler.commands.clear
        compiler.compile_rtmidi
        compiler.compile_ruby_rtmidi_wrapper
        compiler.create_shared_library

        commands.length.should == 3
        commands.should == compiler.commands
      end
    end
  end

end