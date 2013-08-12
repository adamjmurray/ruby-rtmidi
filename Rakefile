
BASEDIR = File.expand_path(File.dirname __FILE__)
RTMIDI_DIR = "#{BASEDIR}/rtmidi-2.0.1"
EXT_DIR = "#{BASEDIR}/ext"

task :default => :make

task :clean do
  Dir.chdir(RTMIDI_DIR)
  system("make clean")
  for file in Dir["#{EXT_DIR}/*.o","#{EXT_DIR}/*.so"]
    puts "Deleting #{file}"
    File.unlink(file)
  end
end

task :configure do
  Dir.chdir(RTMIDI_DIR)
  system("./configure")
end

task :make do
  Dir.chdir(RTMIDI_DIR)
  system("make")

  Dir.chdir(EXT_DIR)
  system("g++ -g -Wall -I#{RTMIDI_DIR} -fPIC -c ruby-rtmidi.cpp")

  # TODO: get this working on Windows and Linux (currently assumes OS X)
  # See http://www.music.mcgill.ca/~gary/rtmidi/index.html#compiling
  system("g++ -g -Wall -I#{RTMIDI_DIR} -I#{RTMIDI_DIR}/include -D__MACOSX_CORE__ -fPIC -shared -o ruby-rtmidi.so " +
    "ruby-rtmidi.o #{RTMIDI_DIR}/RtMidi.o -framework CoreMIDI -framework CoreAudio -framework CoreFoundation")

  puts "Compiled #{EXT_DIR}/ruby-rtmidi.so"
  puts "Test it out by running: ruby lib/rtmidi.rb"
end
