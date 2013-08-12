require "rtmidi"

puts

midiin = RtMidi::In.new
puts "Available MIDI input ports"
midiin.port_names.each_with_index{|name,index| puts "  ##{index+1}: #{name}" }

puts

midiout = RtMidi::Out.new
puts "Available MIDI output ports"
midiout.port_names.each_with_index{|name,index| puts "  ##{index+1}: #{name}" }

puts
