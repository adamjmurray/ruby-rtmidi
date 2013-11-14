require 'spec_helper'

module RtMidi::Interface
  # Avoid method missing errors triggered by the at_exit cleanup code in RtMidi::Out
  def midiout_delete(rtmidi_ptr)
  end
  module_function :midiout_delete
end


describe RtMidi::Out do

  let(:midiout) { RtMidi::Out.new }
  let(:mock_rtmidiout) { :mock_rtmidiout }
  let(:mock_output_ports) { {0 => 'first output', 1 => 'second output', 2 => 'third output'} }

  before do
    RtMidi::Interface.stub(:midiout_new).and_return mock_rtmidiout

    RtMidi::Interface.stub(:midiout_delete).with(:mock_rtmidiout)

    RtMidi::Interface.stub(:midiout_port_count).with(mock_rtmidiout).and_return mock_output_ports.size

    RtMidi::Interface.stub(:midiout_port_name) do |rtmidi_ptr, port_index|
      mock_output_ports[port_index] if rtmidi_ptr == mock_rtmidiout
    end
  end


  describe '#port_count' do
    it 'returns the number of ports available' do
      midiout.port_count.should == mock_output_ports.size
    end
  end

  describe '#port_name' do
    it 'returns the name of the port with the given index' do
      for index,name in mock_output_ports
        midiout.port_name(index).should == name
      end
    end

    it 'returns nil for invalid port indexes' do
      midiout.port_name(mock_output_ports.size).should be_nil
    end
  end

  describe '#port_names' do
    it 'returns the names of the available ports' do
      midiout.port_names.should == mock_output_ports.values
    end
  end

  describe '#open_port' do
    it 'calls RtMidi::Interface.midiout_open_port' do
      RtMidi::Interface.should_receive(:midiout_open_port).with(mock_rtmidiout, 1)
      midiout.open_port(1)
    end
  end

  describe '#close_port' do
    it 'calls RtMidi::Interface.midiout_close_port' do
      RtMidi::Interface.should_receive(:midiout_close_port).with(mock_rtmidiout)
      midiout.close_port
    end
  end

  describe '#send_channel_message' do
    it 'calls RtMidi::Interface.midiout_send_message with 3 ints' do
      RtMidi::Interface.should_receive(:midiout_send_message).with(mock_rtmidiout, 1, 2, 3)
      midiout.send_channel_message(1, 2, 3)
    end
  end

  describe '#send_message' do
    it 'calls RtMidi::Interface.midiout_send_bytes with an int array' do
      RtMidi::Interface.stub(:midiout_send_bytes) do |rtmidi_ptr, bytes|
        rtmidi_ptr.should be mock_rtmidiout
        bytes.should be_a FFI::MemoryPointer
        bytes.read_array_of_int(4).should == [1,2,3,4]
      end
      RtMidi::Interface.should_receive(:midiout_send_bytes)
      midiout.send_message(1, 2, 3, 4)
    end
  end

end