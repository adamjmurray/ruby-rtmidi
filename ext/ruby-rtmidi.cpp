#include "RtMidi.h"
#include "RtError.h"
#include <iostream>

#include "ruby-rtmidi.h"

rtmidi_ptr new_midiin() {
  return static_cast<void *>(new RtMidiIn());
}

void delete_midiin(rtmidi_ptr p) {
  delete static_cast<RtMidiIn *>(p);
}

void print_inputs(rtmidi_ptr p) {
  RtMidiIn *midiin = static_cast<RtMidiIn *>(p);
  
  unsigned int nPorts = midiin->getPortCount();
  std::cout << "There are " << nPorts << " MIDI input sources available.\n";

  for ( unsigned i=0; i<nPorts; i++ ) {
    std::string portName = midiin->getPortName(i);
    std::cout << "  Input Port #" << i+1 << ": " << portName << "\n";
  }
}


rtmidi_ptr new_midiout() {
  return static_cast<void *>(new RtMidiOut());
}

void delete_midiout(rtmidi_ptr p) {
  delete static_cast<RtMidiOut *>(p);
}

void print_outputs(rtmidi_ptr p) {
  RtMidiOut *midiout = static_cast<RtMidiOut *>(p);
  
  unsigned int nPorts = midiout->getPortCount();
  std::cout << "There are " << nPorts << " MIDI output ports available.\n";

  for ( unsigned i=0; i<nPorts; i++ ) {
    std::string portName = midiout->getPortName(i);
    std::cout << "  Output Port #" << i+1 << ": " << portName << "\n";
  }  
}
