load File.expand_path('ext/Rakefile', File.dirname(__FILE__))

desc 'remove artifacts produced by make task'
task :clean do
  for file in Dir["#{RTMIDI_DIR}/*.o", "#{EXT_DIR}/*.o","#{EXT_DIR}/*.so"]
    puts "Deleting #{file}"
    File.unlink(file)
  end
  puts
end
