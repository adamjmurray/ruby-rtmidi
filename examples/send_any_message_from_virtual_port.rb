require "rtmidi"

midiout = RtMidi::Out.new
midiout.open_virtual_port("RubyOutPort")

#correctly close the virtual port
trap "SIGINT" do
  puts
  puts "Closing port and exiting"
  midiout.close_port
  exit 130
end

while true do
	# Now send some SysEx messages
	midiout.send_message(240, 67, 16, 0, 16, 34, 247)
	sleep 0.5
	# or if you prefer a single array argument:
	#note on
	midiout.send_channel_message(145, 60, 53)
	#note off
	sleep 0.2
	midiout.send_channel_message(129, 60, 0)
	sleep 0.5
end

