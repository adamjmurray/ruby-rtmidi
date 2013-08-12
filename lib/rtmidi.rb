require 'ffi'

module RtMidi
  extend FFI::Library
  ffi_lib "ext/ruby-rtmidi.so" # TODO: what should this path look like for a gem?
  
  # rtmidi_ptr create_rtmidiin();
  attach_function :create_midiin, [], :pointer

  # void print_inputs(rtmidi_ptr p);
  attach_function :print_inputs, [:pointer], :void
end


# A quick test:
midiin = RtMidi::create_midiin()
RtMidi::print_inputs(midiin)
