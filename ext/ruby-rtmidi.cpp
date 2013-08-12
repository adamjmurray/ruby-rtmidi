#include "RtMidi.h"
#include "RtError.h"
#include <iostream> // TODO: can probably stop including this later when done debugging

#include "ruby-rtmidi.h"


//================================================
// INPUT

rtmidi_ptr new_midiin() {
  return static_cast<void *>(new RtMidiIn());
}

void delete_midiin(rtmidi_ptr p) {
  delete static_cast<RtMidiIn *>(p);
}

int midiin_port_count(rtmidi_ptr p) {
  RtMidiIn *midiin = static_cast<RtMidiIn *>(p);  
  return midiin->getPortCount();
}

const char * midiin_port_name(rtmidi_ptr p, int port_index) {
  RtMidiIn *midiin = static_cast<RtMidiIn *>(p);  
  int num_ports = midiin->getPortCount();
  if(port_index >= 0 && port_index < num_ports) {
    return midiin->getPortName(port_index).c_str(); // getPortName returns a std::string, use c_str() to be convert to char*
  } else {
    return NULL;
  }  
}


//================================================
// OUTPUT

rtmidi_ptr new_midiout() {
  return static_cast<void *>(new RtMidiOut());
}

void delete_midiout(rtmidi_ptr p) {
  delete static_cast<RtMidiOut *>(p);
}


int midiout_port_count(rtmidi_ptr p) {
  RtMidiOut *midiout = static_cast<RtMidiOut *>(p);  
  return midiout->getPortCount();
}

const char * midiout_port_name(rtmidi_ptr p, int port_index) {
  RtMidiOut *midiout = static_cast<RtMidiOut *>(p);  
  int num_ports = midiout->getPortCount();
  if(port_index >= 0 && port_index < num_ports) {
    return midiout->getPortName(port_index).c_str(); // getPortName returns a std::string, use c_str() to be convert to char*
  } else {
    return NULL;
  }  
}
