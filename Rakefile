
BASEDIR = File.expand_path(File.dirname __FILE__)
RTMIDI_DIR = "#{BASEDIR}/rtmidi-2.0.1"
EXT_DIR = "#{BASEDIR}/ext"


def cd(dir)
  puts "cd #{dir}"
  Dir.chdir(dir)
end

def run(cmd)
  puts cmd
  unless system(cmd)  
    fail "Error: command exited with return value #{$?.exitstatus}" 
  end
end


task :default => :make

task :clean do
  cd RTMIDI_DIR
  run "make clean"
  for file in Dir["#{EXT_DIR}/*.o","#{EXT_DIR}/*.so"]
    puts "Deleting #{file}"
    File.unlink(file)
  end
end

task :configure do
  cd RTMIDI_DIR
  run "./configure"
end

task :make do
  cd RTMIDI_DIR
  run "make"
  puts

  cd EXT_DIR
  run "g++ -g -Wall -I#{RTMIDI_DIR} -fPIC -c ruby-rtmidi.cpp"
  puts

  # TODO: get this working on Windows and Linux (currently assumes OS X)
  # See http://www.music.mcgill.ca/~gary/rtmidi/index.html#compiling
  run "g++ -g -Wall -I#{RTMIDI_DIR} -I#{RTMIDI_DIR}/include -D__MACOSX_CORE__ -fPIC -shared -o ruby-rtmidi.so " +
    "ruby-rtmidi.o #{RTMIDI_DIR}/RtMidi.o -framework CoreMIDI -framework CoreAudio -framework CoreFoundation"
  puts

  puts "Compiled #{EXT_DIR}/ruby-rtmidi.so"
  puts "Test it out by running: ruby examples/list_ports.rb"
end
