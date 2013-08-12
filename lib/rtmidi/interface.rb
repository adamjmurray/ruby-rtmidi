module RtMidi

  module Interface
    extend FFI::Library
    ffi_lib "ext/ruby-rtmidi.so" # TODO: what should this path look like for a gem?
  
    #####################################
    # INPUT
  
    # rtmidi_ptr create_rtmidiin();
    attach_function :new_midiin, [], :pointer
  
    # void delete_midiin(rtmidi_ptr midiin);
    attach_function :delete_midiin, [:pointer], :void
  
    # int midiin_port_count(rtmidi_ptr midiin);
    attach_function :midiin_port_count, [:pointer], :int
  
    # const char * midiin_port_name(rtmidi_ptr midiin, int port_index);
    attach_function :midiin_port_name, [:pointer, :int], :string
  
  
    #####################################
    # OUTPUT
  
    # rtmidi_ptr new_midiout();
    attach_function :new_midiout, [], :pointer
  
    # void delete_midiout(rtmidi_ptr midiout);
    attach_function :delete_midiout, [:pointer], :void
  
   # int midiout_port_count(rtmidi_ptr midiout);
    attach_function :midiout_port_count, [:pointer], :int
  
    # const char * midiout_port_name(rtmidi_ptr midiout, int port_index);
    attach_function :midiout_port_name, [:pointer, :int], :string
  
  end

end
