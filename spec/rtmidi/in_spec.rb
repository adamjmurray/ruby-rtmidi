require 'spec_helper'

module RtMidi::Interface
  # Avoid method missing errors triggered by the at_exit cleanup code in RtMidi::In
  def midiin_delete(rtmidi_ptr)
  end
  module_function :midiin_delete
end


describe RtMidi::In do

  let(:midiin) { RtMidi::In.new }
  let(:mock_rtmidiin) { :mock_rtmidiin }
  let(:mock_input_ports) { {0 => 'first input', 1 => 'second input', 2 => 'third input'} }

  before do
    RtMidi::Interface.stub(:midiin_new).and_return mock_rtmidiin

    RtMidi::Interface.stub(:midiin_delete).with(:mock_rtmidiin)

    RtMidi::Interface.stub(:midiin_port_count).with(mock_rtmidiin).and_return mock_input_ports.size

    RtMidi::Interface.stub(:midiin_port_name) do |rtmidi_ptr, port_index|
      mock_input_ports[port_index] if rtmidi_ptr == mock_rtmidiin
    end
  end


  describe '#port_count' do
    it 'returns the number of ports available' do
      midiin.port_count.should == mock_input_ports.size
    end
  end

  describe '#port_name' do
    it 'returns the name of the port with the given index' do
      for index,name in mock_input_ports
        midiin.port_name(index).should == name
      end
    end

    it 'returns nil for invalid port indexes' do
      midiin.port_name(mock_input_ports.size).should be_nil
    end
  end

  describe '#port_names' do
    it 'returns the names of the available ports' do
      midiin.port_names.should == mock_input_ports.values
    end
  end

  describe '#open_port' do
    it 'calls RtMidi::Interface.midiin_open_port' do
      RtMidi::Interface.should_receive(:midiin_open_port).with(mock_rtmidiin, 1)
      midiin.open_port(1)
    end
  end

  describe '#close_port' do
    it 'calls RtMidi::Interface.midiin_close_port' do
      RtMidi::Interface.should_receive(:midiin_close_port).with(mock_rtmidiin)
      midiin.close_port
    end
  end

  describe '#receive_channel_message' do
    it 'sets up a callback that receives 3 ints' do
      RtMidi::Interface.stub(:midiin_set_callback) do |rtmidi_ptr, callback|
        rtmidi_ptr.should be mock_rtmidiin
        callback.call(1,2,3)
      end

      RtMidi::Interface.should_receive(:midiin_ignore_types).with(mock_rtmidiin, true, true, true)
      RtMidi::Interface.should_receive(:midiin_set_callback)

      received_bytes = []
      midiin.receive_channel_message do |byte1, byte2, byte3|
        received_bytes << byte1
        received_bytes << byte2
        received_bytes << byte3
      end
      received_bytes.should == [1,2,3]
    end
  end

  describe '#receive_message' do
    it 'sets up a callback to receive arbitrary byte lists' do
      RtMidi::Interface.stub(:midiin_set_varargs_callback) do |rtmidi_ptr, callback|
        rtmidi_ptr.should be mock_rtmidiin
        bytes = [1,2,3,4]
        FFI::MemoryPointer.new(:int, bytes.length) do |p|
          p.write_array_of_uchar(bytes)
          callback.call(p, 4)
        end
      end

      RtMidi::Interface.should_receive(:midiin_ignore_types).with(mock_rtmidiin, false, false, false)
      RtMidi::Interface.should_receive(:midiin_set_varargs_callback)

      received_bytes = nil
      midiin.receive_message do |*bytes|
        received_bytes = bytes
      end

      received_bytes.should == [1,2,3,4]
    end
  end

  # TODO: test behavior when calling receive* multiple times

  describe '#stop_receiving' do
    it 'does nothing if no receive callback was setup' do
      midiin.stop_receiving
      # that's it, should have no errors, since we didn't setup stubs or RtMidi::Interface.should_receive expectations
    end

    it 'calls RtMidi::Interface.midiin_cancel_callback if a receive callback was setup' do
      RtMidi::Interface.should_receive(:midiin_ignore_types)
      RtMidi::Interface.should_receive(:midiin_set_varargs_callback)

      midiin.receive_message{|*bytes|}

      RtMidi::Interface.should_receive(:midiin_cancel_callback)

      midiin.stop_receiving
    end
  end

end