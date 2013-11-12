require 'rake/clean'

CLEAN.include %w[ **/*.o  **/*.lib  **/*.obj  **/*.log ]
CLOBBER.include %w[ **/*.so  **/*.dll ]


require 'rspec/core/rake_task'

desc "Run tests"
RSpec::Core::RakeTask.new('test') do |spec|
  spec.rspec_opts = ["--color", "--format", "nested"]
  if ARGV[1]
    # only run specs with filenames starting with the command line argument
    spec.pattern = "spec/**/#{ARGV[1]}*"
  end
end

task :spec => :test  # alias test task as spec task


load File.expand_path('ext/Rakefile', File.dirname(__FILE__))


desc 'Build the gem'
task :gem do
  system 'gem build rtmidi.gemspec'
end