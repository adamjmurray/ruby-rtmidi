module RtMidi

  # Ruby representation of a RtMidiIn C++ object
  # @see Out
  class In

    # Create a new RtMidiIn wrapper object.
    def initialize
      @midiin = Interface::midiin_new()
      at_exit{ Interface::midiin_delete @midiin }
    end

    # The number of MIDI input ports available.
    def port_count      
      @port_count ||= Interface::midiin_port_count(@midiin)
    end

    # The name of the MIDI input port at the given index.
    # @see #port_names
    def port_name(index)
      port_names[index]
    end

    # The list of all MIDI input port names.
    #
    # The index of a port in this list is the index to be passed to {#port_name} and {#open_port}.
    #
    # @see #port_name
    # @see #open_port
    def port_names
      @port_names ||= (
        names = []
        port_count.times{|i| names << Interface::midiin_port_name(@midiin, i) }
        names
      )       
    end

    # Open the MIDI input port at the given index.
    # @see #port_names
    def open_port(index)
      Interface::midiin_open_port(@midiin, index)
    end

    # Close all opened ports.
    def close_ports()
      Interface::midiin_close_port(@midiin)
    end

    # TODO: enable sysex listening by hooking up to midiin_ignore_types
    # but that will require a more flexible callback interface.

    # Setup a callback block to handle incoming MIDI channel messages from opened ports.
    #
    # The block should receive 3 bytes (Ruby integers)
    #
    # All messages are assumed to have 3 bytes.
    # Some channel messages only have 2 bytes in which case the 3rd byte is 0.
    # @example
    #          midiin.set_callback do |byte1, byte2, byte3|
    #            puts "#{byte1} #{byte2} #{byte3}"
    #          end
    # @see #open_port
    # @see #cancel_callback
    def set_callback &callback      
      Interface::midiin_set_callback(@midiin, callback)
    end

    # Cancel previously registered callbacks.
    # @see #set_callback
    def cancel_callback
      Interface::midiin_cancel_callback(@midiin)
    end

  end

end
