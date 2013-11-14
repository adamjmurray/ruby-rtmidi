module RtMidi

  # Object for handling MIDI input.
  # The Ruby representation of a {http://www.music.mcgill.ca/~gary/rtmidi/classRtMidiIn.html RtMidiIn C++ object}..
  # @see Out
  class In

    # Create a new instance.
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
      @port_names ||= (0...port_count).map{|port_index| Interface::midiin_port_name(@midiin, port_index) }
    end

    # Open the MIDI input port at the given index.
    # @note only one port may be open per RtMidi::In instance
    # @see #port_names
    def open_port(index)
      Interface::midiin_open_port(@midiin, index)
    end

    # Close the port, if opened.
    # @see #open_port
    def close_port()
      Interface::midiin_close_port(@midiin)
    end

    # @deprecated use {#close_port}
    def close_ports
      puts "Deprecated, use #close_port instead"
      close_port
    end

    # Setup a callback block to handle incoming MIDI channel messages from opened ports.
    # @note Only one receive callback may be active per RtMidi::In instance.
    #       Calling this method or {#receive_message} multiple times will replace the previous receive callback.
    #
    # The block should receive 3 bytes (Ruby Fixnum integers)
    #
    # All messages are assumed to have 3 bytes. SysEx messages will be ignored.
    # Some channel messages only have 2 bytes in which case the 3rd byte is 0.
    #
    # This is more efficient than {#receive_message} and should be used when handling only MIDI channel messages.
    #
    # @yield [Fixnum, Fixnum, Fixnum] MIDI channel message as individual bytes
    #
    # @example
    #          midiin.receive_channel_message do |byte1, byte2, byte3|
    #            puts "#{byte1} #{byte2} #{byte3}"
    #          end
    #
    # @see #open_port
    # @see #receive_message
    # @see #cancel_callback
    def receive_channel_message &callback
      cancel_callback # otherwise first callback wins. I think last wins is more intuitive
      Interface::midiin_ignore_types(@midiin, true, true, true) # Ignore sysex, timing, or active sensing messages.
      Interface::midiin_set_callback(@midiin, callback)
      @callback_set = true
    end


    # Setup a callback block to handle all incoming MIDI messages from opened ports.
    # @note Only one receive callback may be active per RtMidi::In instance.
    #       Calling this method or {#receive_message} multiple times will replace the previous receive callback.
    #
    # The block should receive a variable number of Ruby Fixnum integers.
    # SysEx messages will be passed to the callback.
    #
    # This is less efficient than {#receive_channel_message} and should only be used when handling
    # SysEx, timing, or active sensing messages.
    #
    # @yield [*Fixnum] MIDI channel message as individual bytes
    #
    # @example
    #          midiin.receive_message do |*bytes|
    #            puts bytes.inspect
    #          end
    #
    # @see #open_port
    # @see #receive_channel_message
    # @see #cancel_callback
    def receive_message &callback
      cancel_callback # otherwise first callback wins. I think last wins is more intuitive
      Interface::midiin_ignore_types(@midiin, false, false, false) #  Don't ignore sysex, timing, or active sensing messages.
      Interface::midiin_set_varargs_callback(@midiin, ->(bytes,size){ yield *bytes.read_array_of_uchar(size) })
      @callback_set = true
    end

    alias set_callback receive_message


    # Cancel the current receive callback, if any.
    # @see #receive_message
    # @see #receive_channel_message
    def stop_receiving
      if @callback_set
        Interface::midiin_cancel_callback(@midiin)
        @callback_set = false
      end
    end

    alias cancel_callback stop_receiving

  end

end
