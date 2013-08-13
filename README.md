ruby-rtmidi
===========

A [Ruby](http://www.ruby-lang.org/) wrapper for [RtMidi](http://www.music.mcgill.ca/~gary/rtmidi/index.html),
a cross-platform C++ library for realtime MIDI input and output.

Once this is further along I intend to release this as a Ruby gem called 'rtmidi'.


Development Notes
=================

Built with [Ruby FFI (foreign function interface)](https://github.com/ffi/ffi),
using [a technique for interfacing with C++ code via C](http://bicosyes.com/2012/11/create-rubyjruby-bindings-of-cc-with-ffi/).

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
