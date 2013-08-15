Ruby-RtMidi
===========

[Ruby](http://www.ruby-lang.org/) wrapper for [RtMidi](http://www.music.mcgill.ca/~gary/rtmidi/index.html),
a cross-platform C++ library for realtime MIDI input and output.

<br>
Features:

* List MIDI I/O ports
* Send 3-byte MIDI messages to output ports
* Listen for 3-byte messages on input ports

In other words, it can handle [channel messages](http://www.cs.cf.ac.uk/Dave/Multimedia/node158.html)
(notes, control change, pitch bend, pressure, program),
but there is no support for [SySex](https://en.wikipedia.org/wiki/SysEx#System_Exclusive_messages) messages yet.

<br>
Supported Platforms:

* OS X
* Windows with [MinGW](http://www.mingw.org/)
* Linux? It compiles on Linux with [JACK](http://jackaudio.org/) but is otherwise untested.

<br>

Requirements
============

To install, you need `gcc` and `g++` on your PATH. Here's the recommended approach for your system:

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
* Use the the MinGW Shell (MSYS) to install

Linux Setup (Ubuntu)
--------------------

    sudo apt-get install g++
    sudo apt-get install jackd
    sudo apt-get install libjack-dev

<br>

Installation
============

Assuming you have Ruby installed, and are ready to compile C++ code with `gcc`, this part is easy:

    gem install rtmidi

<br>

Usage
=====

See the following examples:

* [List MIDI devices](http://rdoc.info/github/adamjmurray/ruby-rtmidi/file/examples/list_ports.rb)
* [MIDI output](http://rdoc.info/github/adamjmurray/ruby-rtmidi/file/examples/play_notes.rb)
* [MIDI input](http://rdoc.info/github/adamjmurray/ruby-rtmidi/file/examples/monitor_input.rb)
