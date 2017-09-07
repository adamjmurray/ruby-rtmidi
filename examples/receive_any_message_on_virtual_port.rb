require "rtmidi"

#Open a virtual MIDI port and recieve any MIDI message.
#To debug you can send midi messages to this port with VMPK a virtual midi piano keyboard
midiin = RtMidi::In.new
midiin.open_virtual_port("RubyInPort")

##############################################################################
# Use this approach when you need to receive any message including:
# System Exclusive (SysEx), timing, active sensing

midiin.receive_message do |*bytes|
  puts bytes.inspect
end

puts "Receiving MIDI messages including SysEx..."
puts "Ctrl+C to exit"

#correctly close the virtual port
trap "SIGINT" do
  puts
  puts "Closing port and exiting"
  midiin.close_port
  exit 130
end

sleep # prevent Ruby from exiting immediately
