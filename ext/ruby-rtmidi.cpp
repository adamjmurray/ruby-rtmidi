#include "RtMidi.h"
#include "RtError.h"
#include <iostream>

#include "ruby-rtmidi.h"

rtmidi_ptr create_midiin() {
  return static_cast<void *>(new RtMidiIn());
}

void print_inputs(rtmidi_ptr p) {
  RtMidiIn *midiin = &(*static_cast<RtMidiIn *>(p));
  
  // Check inputs.
  unsigned int nPorts = midiin->getPortCount();
  std::cout << "\nThere are " << nPorts << " MIDI input sources available.\n";

  for ( unsigned i=0; i<nPorts; i++ ) {
    std::string portName = midiin->getPortName(i);
    std::cout << "  Input Port #" << i+1 << ": " << portName << '\n';
  }
}
