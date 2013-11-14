require "rtmidi"

midiin = RtMidi::In.new


##############################################################################
# Boilerplate code for selecting a MIDI port

puts "Available MIDI input ports"
midiin.port_names.each_with_index{|name,index| printf "%3i: %s\n", index, name }

def select_port(midiio)
  print "Select a port number: "
  if (port = gets) =~ /^\d+$/
    return port.to_i if (0...midiio.port_count).include? port.to_i
  end
  puts "Invalid port number"
end

port_index = select_port(midiin) until port_index

##############################################################################
# Use this approach when you only need to receive channel message like:
# MIDI notes, modulation/CC, pitch bend, aftertouch

midiin.receive_channel_message do |byte1, byte2, byte3|
  puts "#{byte1} #{byte2} #{byte3}"
end

puts "Receiving MIDI channel messages..."
puts "Ctrl+C to exit"

midiin.open_port(port_index)

sleep # prevent Ruby from exiting immediately
