require 'spec_helper'
require 'rtmidi/build/system'

# Stub out the system code and record what was done
module RtMidi::Build::System

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


require 'rtmidi/build/compiler'



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
  let(:cl_compiler) { windows_cl_compiler }
  let(:compilers) { [osx_compiler, windows_gcc_compiler, windows_cl_compiler, linux_jack_compiler, linux_alsa_compiler] }


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
          compiler.command.should =~ /-c\s+RtMidi.cpp/
        end
      end

      it 'outputs RtMidi.o' do
        for compiler in gcc_compilers
          compiler.compile_rtmidi
          compiler.command.should =~ /-o\s+RtMidi.o/
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
        cl_compiler.command.should =~ /\/c\s+RtMidi.cpp/
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

end