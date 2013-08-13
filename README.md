ruby-rtmidi
===========

A [Ruby](http://www.ruby-lang.org/) wrapper for [RtMidi](http://www.music.mcgill.ca/~gary/rtmidi/index.html),
a cross-platform C++ library for realtime MIDI input and output.

Once this is further along I intend to release this as a Ruby gem called 'rtmidi'.


Development Notes
=================

Built with [Ruby FFI (foreign function interface)](https://github.com/ffi/ffi),
using [a technique for interfacing with C++ code via C](http://bicosyes.com/2012/11/create-rubyjruby-bindings-of-cc-with-ffi/).

Currently only working on OS X and Windows under [MinGW](http://www.mingw.org/).

So far you can list MIDI I/O ports, send 3-byte messages to output ports, and listen for 3-byte message on input ports
(in other words, no support for sysex messages yet). 

To build, you need `gcc` on your PATH. Here's the suggested approach for setting up your system

OS X Setup
----------

* Install XCode via the Apple AppStore.
* Open Preferences and install the "Command Line Tools" from the Downloads tab.

See http://stackoverflow.com/questions/9329243/xcode-4-4-command-line-tools if you need help.

Windows Setup
-------------

* Install MinGW from http://sourceforge.net/projects/mingw/files/ (see "Looking for latest version? link near the top).
* During installation, on the "Select Components" screen, install the following:
  * C Compiler
  * C++ COmpiler
  * MSYS Basic System
  * MinGW Developer ToolKit (Not sure this is needed? I installed it during my testing)
* Perform the build steps from the MinGW Shell that was just installed


Building
--------

Once you are setup and you can run the `gcc` command, go to the root of this repository and do:

    bundle install
    bundle exec rake
    ruby -Ilib examples/list_ports.rb
    ruby -Ilib examples/play_notes.rb
    ruby -Ilib examples/monitor_input.rb
