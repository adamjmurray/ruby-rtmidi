module RtMidi

  class Out

    def initialize
      @midiout = Interface::midiout_new()
      at_exit{ Interface::midiout_delete @midiout }
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

    def open_port(index)
      Interface::midiout_open_port(@midiout, index)
    end

    def close_port()
      Interface::midiout_close_port(@midiout)
    end

    def send_message(byte1, byte2, byte3)
      Interface::midiout_send_message(@midiout, byte1, byte2, byte3)
    end

  end

end
