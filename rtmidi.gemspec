Gem::Specification.new do |gem|
  gem.name        = 'rtmidi'
  gem.version     = '0.3'

  gem.summary     = 'Ruby-RtMidi'
  gem.description = 'Ruby wrapper for RtMidi, a cross-platform C++ library for realtime MIDI input and output.'
  gem.author      = 'Adam Murray'
  gem.email       = 'adam@compusition.com'
  gem.homepage    = 'http://github.com/adamjmurray/ruby-rtmidi'
  gem.licenses    = 'BSD'

  gem.files       = Dir['Rakefile', '*.md', 'LICENSE.txt', '.yardopts', 'lib/**/*', 'ext/**/*', 'examples/**/*', 'spec/**/*']

  gem.add_dependency 'ffi', '~> 1.9'

  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'yard', '~> 0.8'

  gem.requirements = ['gcc','g++']
  gem.extensions = ['ext/Rakefile']
  gem.require_paths << 'ext'
end
