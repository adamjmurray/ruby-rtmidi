$LOAD_PATH << File.dirname(__FILE__)+"/../lib"
require "rtmidi"

# A quick test:
puts
midiin = RtMidi::In.new
puts "Available MIDI input ports"
midiin.port_names.each_with_index do |port_name, index|
  puts "  ##{index+1}: #{port_name}"
end
puts

midiout = RtMidi::Out.new
puts "Available MIDI output ports"
midiout.port_names.each_with_index do |port_name, index|
  puts "  ##{index+1}: #{port_name}"
end
puts
