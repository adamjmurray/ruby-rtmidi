require "rtmidi"

midiin = RtMidi::In.new

puts "Available MIDI input ports"
midiin.port_names.each_with_index{|name,index| puts "  #{index+1}: #{name}" }

def select_port(midiin)
  print "Select a port number: "
  if (port_number = gets) =~ /^\d+$/
    port_index = port_number.to_i - 1
    if (0...midiin.port_count).include? port_index
      return port_index
    end
  end
  puts "Invalid port number"
  nil
end

port_index = select_port(midiin) until port_index

midiin.set_varargs_callback do |*bytes|
  puts bytes.inspect
end

puts "Listening for MIDI messages including SysEx..."
puts "Ctrl+C to exit"

midiin.open_port(port_index)

sleep # prevent Ruby from exiting immediately
