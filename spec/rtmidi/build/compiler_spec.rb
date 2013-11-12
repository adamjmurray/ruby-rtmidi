require 'spec_helper'
require 'rtmidi/build/system'

# Stub out the system code and record what was done
module RtMidi::Build::System
  attr_reader :current_dir, :commands
  def cd(dir)
    @current_dir = dir
  end
  def run(cmd)
    (@commands ||= []) << cmd
  end
end
# TODO: stub out mkmf stuff

require 'rtmidi/build/compiler'



describe RtMidi::Build::Compiler do

  let(:ext_dir) { '/ext_dir' }
  let(:rtmidi_dir) { '/rtmidi_dir' }
  subject { RtMidi::Build::Compiler.new(ext_dir, rtmidi_dir, suppress_output: true) }

  def current_dir
    subject.current_dir
  end

  def commands
    subject.commands
  end

  def command
    commands.last
  end

  describe '#compile_rtmidi' do
    before { subject.compile_rtmidi }

    it 'changes the current director to the rtmidi_dir' do
      current_dir.should == rtmidi_dir
    end

    it 'runs a single command' do
      commands.length.should == 1
    end

    context 'compiler type: g++' do
      # TODO: ensure this will be g++ in the context of this test, and add one for cl
      it 'runs g++' do
        command[0..2].should == 'g++'
      end

      it 'includes the subfolder named include' do
        command.should =~ /-Iinclude/
      end

      it 'compiles RtMidi.cpp' do
        command.should =~ /-c\s+RtMidi.cpp/
      end

      it 'outputs RtMidi.o' do
        command.should =~ /-o\s+RtMidi.o/
      end
    end

    context 'compiler type: cl.exe' do

    end
  end

end