require "rtmidi"

midiin = RtMidi::In.new
puts "Available MIDI input ports"
midiin.port_names.each_with_index{|name,index| puts "  ##{index+1}: #{name}" }

port_index = nil
until port_index
  print "Select a port number: "
  input = gets
  if input =~ /\d+/
    index = input.to_i - 1
    port_index = index if index >= 0 and index < midiin.port_count
  end
  puts "Invalid port number" unless port_index
end

midiin.open_port(port_index)

midiin.set_callback()

puts "Ctrl+C to exit"
loop{ sleep 1 }
