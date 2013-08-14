BASEDIR = File.expand_path(File.dirname __FILE__)
EXT_DIR = "#{BASEDIR}/ext"
RTMIDI_DIR = "#{EXT_DIR}/rtmidi-2.0.1"

HOST_OS = RbConfig::CONFIG['host_os'].downcase
OS_X = (HOST_OS =~ /darwin/)
WINDOWS = ((HOST_OS =~ /win/ and HOST_OS !~ /darwin/) or HOST_OS =~ /mingw/)
LINUX = (HOST_OS =~ /linux/)


def cd(dir)
  puts "cd #{dir}"
  Dir.chdir(dir)
end

def run(cmd)
  puts cmd
  unless system(cmd)
    puts "Error: command exited with return value #{$?.exitstatus}"
    exit $?.exitstatus
  end
end


task :default =>  [:clean, :make]


task :clean do
  for file in Dir["#{RTMIDI_DIR}/*.o", "#{EXT_DIR}/*.o","#{EXT_DIR}/*.so"]
    puts "Deleting #{file}"
    File.unlink(file)
  end
  puts
end


task :make do
  predefine = case
    when OS_X then "__MACOSX_CORE__"
    when WINDOWS then "__WINDOWS_MM__"
    when LINUX then "__UNIX_JACK__" # TODO: could also be "__LINUX_ALSA__"
    else
  end

  system_libraries = case
    when OS_X then "-framework CoreMIDI -framework CoreAudio -framework CoreFoundation"
    when WINDOWS then "-lwinmm"
    when LINUX then "-ljack" # TODO: could also be "-lasound -lpthread" for ALSA
    else
  end

  cd RTMIDI_DIR
  run "g++ -O3 -Wall -Iinclude -fPIC -D#{predefine} -c RtMidi.cpp -o RtMidi.o"
  puts

  cd EXT_DIR
  run "g++ -g -Wall -I#{RTMIDI_DIR} -fPIC -c ruby-rtmidi.cpp"
  puts
  run "g++ -g -Wall -I#{RTMIDI_DIR} -I#{RTMIDI_DIR}/include -D#{predefine} -fPIC -shared -o ruby-rtmidi.so " +
          "ruby-rtmidi.o #{RTMIDI_DIR}/RtMidi.o #{system_libraries}"
  puts

  puts "Compiled #{EXT_DIR}/ruby-rtmidi.so"
  puts "Test it out by running: ruby -Ilib examples/list_ports.rb"
end
