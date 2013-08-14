module RtMidi

  # Ruby representation of an RtMidiIn C++ object
  class In

    def initialize
      @midiin = Interface::midiin_new()
      at_exit{ Interface::midiin_delete @midiin }
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

    def open_port(index)
      Interface::midiin_open_port(@midiin, index)
    end

    def close_port()
      Interface::midiin_close_port(@midiin)
    end

    # TODO: enable sysex listening by hooking up to midiin_ignore_types
    # but that will require a more flexible callback interface

    #
    def set_callback &callback      
      Interface::midiin_set_callback(@midiin, callback)
    end

    def cancel_callback
      Interface::midiin_cancel_callback(@midiin)
    end

  end

end
