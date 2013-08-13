
BASEDIR = File.expand_path(File.dirname __FILE__)
RTMIDI_DIR = "#{BASEDIR}/rtmidi-2.0.1"
EXT_DIR = "#{BASEDIR}/ext"

WINDOWS = (
  os = RbConfig::CONFIG['host_os'].downcase
  (os =~ /win/ and os !~ /darwin/) or os =~ /mingw/
)

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


task :default =>  [:clean, :configure, :make]


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
  if WINDOWS
    # For some reason, configure cannot be shell exec'd on Windows/MinGW.
    # This sh script wrapper somehow works around the problem.
    run "sh configure.sh"
  else
    run "./configure"
  end
end

task :make do
  cd RTMIDI_DIR
  run "make"
  puts

  cd EXT_DIR
  run "g++ -g -Wall -I#{RTMIDI_DIR} -fPIC -c ruby-rtmidi.cpp"
  puts

  # TODO: get this working on Linux
  # See http://www.music.mcgill.ca/~gary/rtmidi/index.html#compiling
  predefine = (
    if WINDOWS
      "__WINDOWS_MM__"
    else
      "__MACOSX_CORE__"
    end
    # TODO: linux should be "__UNIX_JACK__" or "__LINUX_ALSA__"
  )
  system_libraries = (
    if WINDOWS
      "-lwinmm"
    else
      "-framework CoreMIDI -framework CoreAudio -framework CoreFoundation"
    end
    # TODO: linux should be "-ljack" for Jack
    # or "-lasound -lpthread" for ALSA
  )

  run "g++ -g -Wall -I#{RTMIDI_DIR} -I#{RTMIDI_DIR}/include -D#{predefine} -fPIC -shared -o ruby-rtmidi.so " +
    "ruby-rtmidi.o #{RTMIDI_DIR}/RtMidi.o #{system_libraries}"
  puts

  puts "Compiled #{EXT_DIR}/ruby-rtmidi.so"
  puts "Test it out by running: ruby -Ilib examples/list_ports.rb"
end
