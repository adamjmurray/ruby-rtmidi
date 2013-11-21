require 'spec_helper'

describe RtMidi::Build::System do

  class SystemIncluder
    include RtMidi::Build::System
  end

  subject { SystemIncluder.new }

  def stub_osx
    RbConfig::CONFIG['host_os'] = 'darwin12.4.0'
  end

  def stub_windows
    RbConfig::CONFIG['host_os'] = 'mswin'
  end

  def stub_mingw
    RbConfig::CONFIG['host_os'] = 'mingw32'
  end

  def stub_linux
    RbConfig::CONFIG['host_os'] = 'linux'
  end


  describe '#platform' do
    it 'returns :osx on OS X' do
      stub_osx
      subject.platform.should == :osx
    end

    it 'returns :windows on Windows' do
      stub_windows
      subject.platform.should == :windows
    end

    it 'returns :windows under MinGW on Windows' do
      stub_mingw
      subject.platform.should == :windows
    end

    it 'returns :linux on Linux' do
      stub_linux
      subject.platform.should == :linux
    end
  end

  describe '#osx?' do
    it 'returns true on OS X' do
      stub_osx
      subject.osx?.should be_true
    end

    it 'returns false otherwise' do
      [->{stub_windows}, ->{stub_mingw}, ->{stub_linux}].each do |stubber|
        stubber.call
        subject.osx?.should be_false
      end
    end
  end

  describe '#windows?' do
    it 'returns true on Windows' do
      [->{stub_windows}, ->{stub_mingw}].each do |stubber|
        stubber.call
        subject.windows?.should be_true
      end
    end

    it 'returns false otherwise' do
      [->{stub_osx}, ->{stub_linux}].each do |stubber|
        stubber.call
        subject.windows?.should be_false
      end
    end
  end

  describe '#linux?' do
    it 'returns true on Linux' do
      stub_linux
      subject.linux?.should be_true
    end

    it 'returns false otherwise' do
      [->{stub_osx}, ->{stub_windows}, ->{stub_mingw}].each do |stubber|
        stubber.call
        subject.linux?.should be_false
      end
    end
  end

  describe 'cd' do
    it 'calls Dir.chdir' do
      s = subject
      s.stub(:puts) # suppress output
      Dir.stub(:chdir).with 'foo'
      s.cd 'foo'
    end
  end

  describe 'can_run' do
    it 'calls find_executable' do
      s = subject
      s.stub(:find_executable).with 'foo'
      s.can_run 'foo'
    end
  end

  describe 'run' do
    it 'calls system() to run the command' do
      s = subject
      s.stub(:puts) # suppress output
      s.stub(:system).with('foo').and_return true
      s.run 'foo'
    end

    it 'calls exits with $?.exitstatus when system() returns false' do
      s = subject
      s.stub(:puts) # suppress output
      s.stub(:system).with('foo').and_return false
      allow_message_expectations_on_nil
      $?.stub(:exitstatus).and_return :status
      s.stub(:exit).with :status
      s.run 'foo'
    end
  end

end