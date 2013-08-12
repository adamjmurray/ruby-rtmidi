
BASEDIR = File.expand_path(File.dirname __FILE__)
RTMIDI_DIR = "#{BASEDIR}/rtmidi-2.0.1"

task :default => :make

task :clean do
  Dir.chdir(RTMIDI_DIR)
  system('make clean')
end

task :configure do
  Dir.chdir(RTMIDI_DIR)
  system('./configure')
end

task :make do
  Dir.chdir(RTMIDI_DIR)
  system('make')
end

