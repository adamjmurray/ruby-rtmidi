require "rtmidi"

midiout = RtMidi::Out.new
puts "Available MIDI output ports"
midiout.port_names.each_with_index{|name,index| puts "  ##{index+1}: #{name}" }

port_index = nil
until port_index
  print "Select a port number: "
  input = gets
  if input =~ /\d+/
    index = input.to_i - 1
    port_index = index if index >= 0 and index < midiout.port_count
  end
  puts "Invalid port number" unless port_index
end

midiout.open_port(port_index)

for pitch in [60, 62, 64, 65, 67]
  midiout.send_message(0x90, pitch, 127) # note on
  sleep 0.5
  midiout.send_message(0x90, pitch, 0) # note off
end
