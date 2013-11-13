require "rtmidi"

midiout = RtMidi::Out.new

puts "Available MIDI output ports"
midiout.port_names.each_with_index{|name,index| puts "  #{index+1}: #{name}" }

def select_port(midiout)
  print "Select a port number: "
  if (port_number = gets) =~ /^\d+$/
    port_index = port_number.to_i - 1
    if (0...midiout.port_count).include? port_index
      return port_index
    end
  end
  puts "Invalid port number"
  nil
end

port_index = select_port(midiout) until port_index
midiout.open_port(port_index)

midiout.send_bytes(240, 67, 16, 0, 16, 34, 247)
# or if you prefer
midiout.send_bytes( [240, 67, 16, 0, 16, 35, 247] )
