Ruby-RtMidi
===========

[![Gem Version](https://badge.fury.io/rb/rtmidi.png)](http://badge.fury.io/rb/rtmidi) [![Build Status](https://travis-ci.org/adamjmurray/ruby-rtmidi.png?branch=master)](https://travis-ci.org/adamjmurray/ruby-rtmidi)

[Ruby](http://www.ruby-lang.org/) wrapper for [RtMidi](http://www.music.mcgill.ca/~gary/rtmidi/index.html),
a cross-platform C++ library for realtime MIDI input and output.

Features:

* List MIDI I/O ports
* Send MIDI messages to output ports
* Receive messages on input ports
* Open named virtual MIDI IN and OUT ports (not supported on Windows)

In other words, everything you'd want from a low-level MIDI library.
It's still your responsibility to interpret the MIDI message byte streams!

Supported Platforms:

* OS X
* Windows
* Linux


Requirements
============

To install, you need `gcc` and `g++` on your PATH.

On Windows, you can use Visual Studio's `cl.exe` compiler instead.

Here's the recommended approach for your system:

OS X Setup
----------

* Install XCode via the Apple AppStore.
* Open XCode's Preferences and install "Command Line Tools" in the Downloads tab.

See [this stackoverflow discussion](http://stackoverflow.com/questions/9329243/xcode-4-4-command-line-tools) for help.

Windows Setup
-------------

### with [Visual Studio](http://www.microsoft.com/visualstudio) (cl.exe)
* Install [Visual Studio](http://www.microsoft.com/visualstudio) (Tested with Visual C++ 2010 Express. Any recent version with a C++ compiler should work.)
* Use the "Visual Studio Command Prompt" to install

### with [MinGW](http://www.mingw.org/) (gcc/g++)
* [Install MinGW](http://sourceforge.net/projects/mingw/files/latest/download)
* During installation, on the "Select Components" screen, install the following:
  * C Compiler
  * C++ Compiler
  * MSYS Basic System
  * MinGW Developer ToolKit
* Use the the MinGW Shell (MSYS) to install

Note: when installing under MinGW, this library may not work outside of MinGW. If that is a problem for you, use Visual Studio to install.

Linux Setup
-----------

Install [JACK](http://jackaudio.org/) or [ALSA](http://www.alsa-project.org).

This should work on Ubuntu:

    sudo apt-get install g++
    sudo apt-get install jackd
    sudo apt-get install libjack-dev


Installation
============

Assuming you have Ruby installed, and are ready to compile C++ code with `gcc`, this part is easy:

    gem install rtmidi


Usage
=====

See the following examples:

* [list MIDI devices](http://rdoc.info/github/adamjmurray/ruby-rtmidi/file/examples/list_ports.rb)
* [MIDI channel output](http://rdoc.info/github/adamjmurray/ruby-rtmidi/file/examples/send_channel_message.rb)
* [MIDI channel input](http://rdoc.info/github/adamjmurray/ruby-rtmidi/file/examples/receive_channel_message.rb)
* [arbitrary MIDI output](http://rdoc.info/github/adamjmurray/ruby-rtmidi/file/examples/send_any_message.rb)
* [arbitrary MIDI input](http://rdoc.info/github/adamjmurray/ruby-rtmidi/file/examples/receive_any_message.rb)
* [Open a virtual IN/OUT MIDI port] see also the examples

Use the arbitrary MIDI IO to handle channel messages, SysEx, timing, and/or active sensing messages.
If you only need channel messages (notes, modulation/CC, pitch bend, aftertouch), it's recommended you
follow the channel IO examples.




Documentation
=============

[http://rdoc.info/github/adamjmurray/ruby-rtmidi/frames](http://rdoc.info/github/adamjmurray/ruby-rtmidi/frames)


Contributing
============

Pull requests are welcome. The following must work:

* `rake test` shows all unit tests are passing
* Build and test the gem manually:
    * `gem build rtmidi.gemspec`
    * `gem install rtmidi-#{version}.gem`
    * the examples can be run successfully against this version of the gem (`ruby examples/**`)


Changelog
=========

* 0.4 - Support for virtual midi ports
* 0.3 - Support for arbitrary MIDI messages including SysEx
* 0.2.2 - Compilable with Visual Studio on Windows
* 0.2.1 - Linux support (thanks to [@quark-zju](https://github.com/quark-zju))
* 0.2 - First stable release
