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
# Use this approach when you only need to send channel message like:
# MIDI notes, modulation/CC, pitch bend, aftertouch

midiout.open_port(port_index)

for pitch in [60, 62, 64, 65, 67]
  midiout.send_message(0x90, pitch, 127) # note on
  sleep 0.5
  midiout.send_message(0x90, pitch, 0) # note off
end

sleep 0.5 # give the final note off time to release
