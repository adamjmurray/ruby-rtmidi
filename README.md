ruby-rtmidi
===========

Ruby wrapper for the RtMidi C++ library

RtMidi is a cross-platform library for realtime MIDI input and output.
Learn more about RtMidi at http://www.music.mcgill.ca/~gary/rtmidi/index.html

This will be built with Ruby FFI (https://github.com/ffi/ffi) and techniques for wrapping C++ code with C interfaces as explained at http://bicosyes.com/2012/11/create-rubyjruby-bindings-of-cc-with-ffi/

Once this is further along I intend to release this as a Ruby gem called 'rtmidi'.


Development Notes
=================

Currently only working on OS X.
So far, just have a basic proof-of-concept to list the available MIDI inputs and outputs via Ruby.

To build, you need XCode and the command line tools. Specifically, you need g++ on your PATH. 
Then, from the root of this repository you can do:

    bundle install
    bundle exec rake
    ruby examples/list_ports.rb
