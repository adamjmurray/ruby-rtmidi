ruby-rtmidi
===========

Ruby wrapper for the RtMidi C++ library

RtMidi is a cross-platform library for realtime MIDI input and output.
Learn more about RtMidi at http://www.music.mcgill.ca/~gary/rtmidi/index.html

This will be built with Ruby FFI (https://github.com/ffi/ffi) and techniques for wrapping C++ code with C interfaces as explained at http://bicosyes.com/2012/11/create-rubyjruby-bindings-of-cc-with-ffi/

Once this is further along I intend to release this as a Ruby gem called 'rtmidi'.


Development Notes
=================

Currently only working on OS X (although in theory it will work on Windows if you compile the ext folder manually).
So far you can list MIDI I/O ports, send 3-byte messages to output ports, and listen for 3-byte message on input ports
(in other words, no support for sysex messages yet). 

To build, you need XCode and the command line tools. Specifically, you need g++ on your PATH. 
Then, from the root of this repository you can do:

    bundle install
    bundle exec rake
    ruby -Ilib examples/list_ports.rb
    ruby -Ilib examples/play_notes.rb
    ruby -Ilib examples/monitor_input.rb
