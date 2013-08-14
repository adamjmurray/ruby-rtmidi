Ruby-RtMidi
===========

[Ruby](http://www.ruby-lang.org/) wrapper for [RtMidi](http://www.music.mcgill.ca/~gary/rtmidi/index.html),
a cross-platform C++ library for realtime MIDI input and output.

Soon to be released as a Ruby gem called 'rtmidi'.

Features:
* List MIDI I/O ports
* Send 3-byte MIDI messages to output ports
* Listen for 3-byte messages on input ports

(in other words, no support for sysex messages yet).

Supported Platforms:
* OS X
* Windows with [MinGW](http://www.mingw.org/)
* Linux? It compiles on Linux with [JACK](http://jackaudio.org/) but is otherwise untested.


Development Notes
=================

Built with [Ruby FFI (foreign function interface)](https://github.com/ffi/ffi),
using [a technique for interfacing with C++ code via C](http://bicosyes.com/2012/11/create-rubyjruby-bindings-of-cc-with-ffi/).

To build, you need `gcc` on your PATH. Here's the suggested approach for setting up gcc on your system

OS X Setup
----------

* Install XCode via the Apple AppStore.
* Open Preferences and install the "Command Line Tools" from the Downloads tab.

See [this stackoverflow discussion](http://stackoverflow.com/questions/9329243/xcode-4-4-command-line-tools) for help.

Windows Setup
-------------

* [Install MinGW](http://sourceforge.net/projects/mingw/files/)  (see "Looking for the latest version?" link)
* During installation, on the "Select Components" screen, install the following:
  * C Compiler
  * C++ Compiler
  * MSYS Basic System
  * MinGW Developer ToolKit
* Perform the build steps from the MinGW Shell that was just installed

Linux Setup (Ubuntu)
--------------------

    sudo apt-get install g++
    sudo apt-get install jackd
    sudo apt-get install libjack-dev

Building
--------

Once you are setup and you can run the `gcc` command, go to the root of this repository and do:

    bundle install
    bundle exec rake
    ruby -Ilib examples/list_ports.rb
    ruby -Ilib examples/play_notes.rb
    ruby -Ilib examples/monitor_input.rb
