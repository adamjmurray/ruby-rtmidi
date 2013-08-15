Built with [Ruby FFI (foreign function interface)](https://github.com/ffi/ffi),
using [a technique for interfacing with C++ code via C](http://bicosyes.com/2012/11/create-rubyjruby-bindings-of-cc-with-ffi/).

Building
--------

Once you are setup and you can run the `gcc` command, go to the root of this repository and do:

    bundle install
    bundle exec rake
    ruby -Ilib examples/list_ports.rb
    ruby -Ilib examples/play_notes.rb
    ruby -Ilib examples/monitor_input.rb