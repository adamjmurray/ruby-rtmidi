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

    # Setup a callback block to handle incoming MIDI channel messages from opened ports.
    # Only one callback may be active at a time.
    #
    # The block should receive 3 bytes (Ruby integers)
    #
    # All messages are assumed to have 3 bytes. SysEx messages will be ignored.
    # Some channel messages only have 2 bytes in which case the 3rd byte is 0.
    # @example
    #          midiin.set_callback do |byte1, byte2, byte3|
    #            puts "#{byte1} #{byte2} #{byte3}"
    #          end
    # @see #open_port
    # @see #set_varargs_callback
    # @see #cancel_callback
    def set_callback &callback
      cancel_callback # otherwise first callback wins. I think last wins is more intuitive
      Interface::midiin_ignore_types(@midiin, true, true, true) # Ignore sysex, timing, or active sensing messages.
      Interface::midiin_set_callback(@midiin, callback)
      @callback_set = true
    end

    # Setup a callback block to handle all incoming MIDI messages from opened ports.
    # Only one callback may be active at a time.
    #
    # The block should receive a variable number of Ruby integers.
    # SysEx messages will be passed to the callback.
    #
    # @example
    #          midiin.set_varargs_callback do |*bytes|
    #            puts bytes.inspect
    #          end
    # @see #open_port
    # @see #set_callback
    # @see #cancel_callback
    def set_varargs_callback &callback
      cancel_callback # otherwise first callback wins. I think last wins is more intuitive
      Interface::midiin_ignore_types(@midiin, false, false, false) #  Don't ignore sysex, timing, or active sensing messages.
      callback_wrapper = lambda do |bytes, size|
        yield *bytes.get_bytes(0, size).each_char.map{|c| c.ord }
      end
      Interface::midiin_set_varargs_callback(@midiin, callback_wrapper)
      @callback_set = true
    end

    # Cancel the current callback, if any.
    # @see #set_callback
    def cancel_callback
      if @callback_set
        Interface::midiin_cancel_callback(@midiin)
        @callback_set = false
      end
    end

  end

end
