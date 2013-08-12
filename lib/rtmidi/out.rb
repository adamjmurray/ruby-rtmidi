module RtMidi

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
