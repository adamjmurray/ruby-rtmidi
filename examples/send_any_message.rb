require "rtmidi"

midiout = RtMidi::Out.new


##############################################################################
# Boilerplate code for selecting a MIDI port

puts "Available MIDI output ports"
midiout.port_names.each_with_index{|name,index| printf "%3i: %s\n", index, name }

def select_port(midiio)
  print "Select a port number: "
  if (port = gets) =~ /^\d+$/
    return port.to_i if (0...midiio.port_count).include? port.to_i
  end
  puts "Invalid port number"
end

port_index = select_port(midiout) until port_index

##############################################################################
# Use this approach when you need to send any message including:
# System Exclusive (SysEx), timing, active sensing

midiout.open_port(port_index)

# Now send some SysEx messages
midiout.send_message(240, 67, 16, 0, 16, 34, 247)
# or if you prefer a single array argument:
midiout.send_message( [240, 67, 16, 0, 16, 35, 247] )
