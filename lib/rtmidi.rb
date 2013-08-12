require 'ffi'

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


  class In

    def initialize
      @midiin = Interface::new_midiin()
      at_exit{ Interface::delete_midiin @midiin }
    end

    def port_count      
      @port_count ||= Interface::midiin_port_count(@midiin)
    end

    def port_name(index)
      port_names[index]
    end

    def port_names
      @port_namess ||= (
        names = []
        port_count.times{|i| names << Interface::midiin_port_name(@midiin, i) }
        names
      )       
    end

  end


  class Out

    def initialize
      @midiout = Interface::new_midiout()
      at_exit{ Interface::delete_midiout @midiout }
    end

    def port_count      
      @port_count ||= Interface::midiout_port_count(@midiout)
    end

    def port_name(index)
      port_names[index]
    end

    def port_names
      @port_namess ||= (
        names = []
        port_count.times{|i| names << Interface::midiout_port_name(@midiout, i) }
        names
      )       
    end

  end

end


# A quick test:
puts
midiin = RtMidi::In.new
puts "Available MIDI input ports"
midiin.port_names.each_with_index do |port_name, index|
  puts "  ##{index+1}: #{port_name}"
end
puts

midiout = RtMidi::Out.new
puts "Available MIDI output ports"
midiout.port_names.each_with_index do |port_name, index|
  puts "  ##{index+1}: #{port_name}"
end
puts
