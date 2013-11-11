require 'rake/clean'

CLEAN.include('**/*.o', '**/*.lib', '**/*.obj', '**/*.log')
CLOBBER.include('**/*.so', '**/*.dll')

load File.expand_path('ext/Rakefile', File.dirname(__FILE__))

desc 'build the gem'
task :gem do
  system 'gem build rtmidi.gemspec'
end