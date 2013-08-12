require 'ffi'

module RtMidi
  extend FFI::Library
  ffi_lib "ext/ruby-rtmidi.so" # TODO: what should this path look like for a gem?
  
  # rtmidi_ptr create_rtmidiin();
  attach_function :new_midiin, [], :pointer

  # void delete_midiin(rtmidi_ptr midiin);
  attach_function :delete_midiin, [:pointer], :void

  # void print_inputs(rtmidi_ptr p);
  attach_function :print_inputs, [:pointer], :void


  # rtmidi_ptr new_midiout();
  attach_function :new_midiout, [], :pointer

  # void delete_midiout(rtmidi_ptr midiout);
  attach_function :delete_midiout, [:pointer], :void

  # void print_outputs(rtmidi_ptr midiout);
  attach_function :print_outputs, [:pointer], :void

end


# A quick test:
midiin = RtMidi::new_midiin()
midiout = RtMidi::new_midiout()

at_exit do
  RtMidi::delete_midiin(midiin)
  RtMidi::delete_midiout(midiout)
end

puts
RtMidi::print_inputs(midiin)
puts
RtMidi::print_outputs(midiout)
puts
