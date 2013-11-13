module RtMidi

  # Ruby representation of a RtMidiOut C++ object
  # @see In
  class Out

    # Create a new RtMidiOut wrapper object.
    def initialize
      @midiout = Interface::midiout_new()
      at_exit{ Interface::midiout_delete @midiout }
    end

    # The number of MIDI output ports available.
    def port_count      
      @port_count ||= Interface::midiout_port_count(@midiout)
    end

    # The name of the MIDI output port at the given index.
    # @see #port_names
    def port_name(index)
      port_names[index]
    end

    # The list of all MIDI output port names.
    #
    # The index of a port in this list is the index to be passed to {#port_name} and {#open_port}.
    #
    # @see #port_name
    # @see #open_port
    def port_names
      @port_names ||= (
        names = []
        port_count.times{|i| names << Interface::midiout_port_name(@midiout, i) }
        names
      )       
    end

    # Open the MIDI output port at the given index.
    # @see #port_names
    def open_port(index)
      Interface::midiout_open_port(@midiout, index)
    end

    # Close all opened ports.
    def close_ports()
      Interface::midiout_close_port(@midiout)
    end

    # Send a 2 or 3 byte MIDI channel message to the opened port.
    #
    # Some channel messages only have 2 bytes in which case the 3rd byte is ignored.
    # @see #open_port
    # @see #send_bytes
    def send_message(byte1, byte2, byte3=0)
      Interface::midiout_send_message(@midiout, byte1, byte2, byte3)
    end

    # Send an arbitrary multi-byte MIDI message to the opened port.
    # This supports SysEx messages.
    #
    # @see #open_port
    # @see #send_message
    def send_bytes(*bytes)
      bytes.flatten!
      FFI::MemoryPointer.new(:int, bytes.length) do |p|
        p.write_array_of_int(bytes)
        Interface::midiout_send_bytes(@midiout, p, bytes.length)
      end
    end

  end

end
