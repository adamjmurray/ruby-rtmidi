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
# Use this approach when you need to receive any message including:
# System Exclusive (SysEx), timing, active sensing

midiin.receive_message do |*bytes|
  puts bytes.inspect
end

puts "Receiving MIDI messages including SysEx..."
puts "Ctrl+C to exit"

midiin.open_port(port_index)

sleep # prevent Ruby from exiting immediately
