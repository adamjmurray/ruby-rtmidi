module RtMidi

  # @private
  module Interface
    extend FFI::Library
    ffi_lib [
      File.expand_path("../../ext/ruby-rtmidi.so", File.dirname(__FILE__)),
      File.expand_path("../../ext/ruby-rtmidi.dll", File.dirname(__FILE__))
    ]
  
    #####################################
    # INPUT
  
    # rtmidi_ptr create_rtmidiin();
    attach_function :midiin_new, [], :pointer
  
    # void delete_midiin(rtmidi_ptr midiin);
    attach_function :midiin_delete, [:pointer], :void
  
    # int midiin_port_count(rtmidi_ptr midiin);
    attach_function :midiin_port_count, [:pointer], :int
  
    # const char * midiin_port_name(rtmidi_ptr midiin, int port_index);
    attach_function :midiin_port_name, [:pointer, :int], :string
  
    # void midiin_open_port(rtmidi_ptr p, int port_index);
    attach_function :midiin_open_port, [:pointer, :int], :void

    # void midiin_virtual_port(rtmidi_ptr p);
    #attach_function :midiin_open_virtual_port, [:pointer], :void
    
    # void midiin_virtual_port(rtmidi_ptr p,char* str);
    attach_function :midiin_open_virtual_port, [:pointer, :string ], :void

    # void midiin_close_port(rtmidi_ptr p, int port_index);
    attach_function :midiin_close_port, [:pointer], :void

    # void midiin_ignore_types(rtmidi_ptr p, bool sysex, bool timing, bool active_sensing);
    attach_function :midiin_ignore_types, [:pointer, :bool, :bool, :bool], :void

    # void midiin_set_callback(rtmidi_ptr p, rtmidi_callback callback);
    callback :rtmidi_callback, [:int, :int, :int], :void
    attach_function :midiin_set_callback, [:pointer, :rtmidi_callback], :void




    # void midiin_set_varargs_callback(rtmidi_ptr p, rtmidi_varargs_callback callback);
    callback :rtmidi_varargs_callback, [:pointer, :int], :void
    attach_function :midiin_set_varargs_callback, [:pointer, :rtmidi_varargs_callback], :void

    # void midiin_cancel_callback(rtmidi_ptr p);
    attach_function :midiin_cancel_callback, [:pointer], :void


    #####################################
    # OUTPUT
  
    # rtmidi_ptr new_midiout();
    attach_function :midiout_new, [], :pointer
  
    # void delete_midiout(rtmidi_ptr midiout);
    attach_function :midiout_delete, [:pointer], :void
  
   # int midiout_port_count(rtmidi_ptr midiout);
    attach_function :midiout_port_count, [:pointer], :int
  
    # const char * midiout_port_name(rtmidi_ptr midiout, int port_index);
    attach_function :midiout_port_name, [:pointer, :int], :string

    # void midiout_virtual_port(rtmidi_ptr p);
    #attach_function :midiout_open_virtual_port, [:pointer], :void
    
    # void midiout_virtual_port(rtmidi_ptr p,char* str);
    attach_function :midiout_open_virtual_port, [:pointer, :string ], :void

    # void midiout_open_port(rtmidi_ptr p, int port_index);
    attach_function :midiout_open_port, [:pointer, :int], :void
  
    # void midiout_close_port(rtmidi_ptr p);
    attach_function :midiout_close_port, [:pointer], :void

    # void midiout_send_message(rtmidi_ptr p, int byte1, int byte2, int byte3);
    attach_function :midiout_send_message, [:pointer, :int, :int, :int], :void

    # void midiout_send_bytes(rtmidi_ptr p, int* bytes);
    attach_function :midiout_send_bytes, [:pointer, :pointer, :int], :void
  end

end
