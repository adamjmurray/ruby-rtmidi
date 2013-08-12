#include "RtMidi.h"
#include "RtError.h"
#include <vector>
#include <iostream> // TODO: can probably stop including this later when done debugging

#include "ruby-rtmidi.h"


//================================================
// INPUT

rtmidi_ptr midiin_new() {
  return static_cast<void *>(new RtMidiIn());
}

void midiin_delete(rtmidi_ptr p) {
  delete static_cast<RtMidiIn *>(p);
}

int midiin_port_count(rtmidi_ptr p) {
  RtMidiIn *midiin = static_cast<RtMidiIn *>(p);  
  return midiin->getPortCount();
}

const char* midiin_port_name(rtmidi_ptr p, int port_index) {
  RtMidiIn *midiin = static_cast<RtMidiIn *>(p);  
  return midiin->getPortName(port_index).c_str(); // getPortName returns a std::string, use c_str() to be convert to char*
}

void midiin_open_port(rtmidi_ptr p, int port_index) {
  RtMidiIn *midiin = static_cast<RtMidiIn *>(p);
  midiin->openPort(port_index);
}

void midiin_close_port(rtmidi_ptr p) {
  RtMidiIn *midiin = static_cast<RtMidiIn *>(p);
  midiin->closePort();
}

void midiin_ignore_types(rtmidi_ptr p, bool sysex, bool timing, bool active_sensing) {
  RtMidiIn *midiin = static_cast<RtMidiIn *>(p);
  midiin->ignoreTypes(sysex, timing, active_sensing);
}

void mycallback( double deltatime, std::vector< unsigned char > *message, void *userData )
{
  unsigned int nBytes = message->size();
  for ( unsigned int i=0; i<nBytes; i++ )
    std::cout << "Byte " << i << " = " << (int)message->at(i) << ", ";
  if ( nBytes > 0 )
    std::cout << "stamp = " << deltatime << std::endl;
}

void midiin_set_callback(rtmidi_ptr p) { // TODO: actually set a callback
  RtMidiIn *midiin = static_cast<RtMidiIn *>(p);
  midiin->setCallback( &mycallback );
}


//================================================
// OUTPUT

rtmidi_ptr midiout_new() {
  return static_cast<void *>(new RtMidiOut());
}

void midiout_delete(rtmidi_ptr p) {
  delete static_cast<RtMidiOut *>(p);
}

int midiout_port_count(rtmidi_ptr p) {
  RtMidiOut *midiout = static_cast<RtMidiOut *>(p);  
  return midiout->getPortCount();
}

const char* midiout_port_name(rtmidi_ptr p, int port_index) {
  RtMidiOut *midiout = static_cast<RtMidiOut *>(p);  
  return midiout->getPortName(port_index).c_str(); // getPortName returns a std::string, use c_str() to be convert to char*
}

void midiout_open_port(rtmidi_ptr p, int port_index) {
  RtMidiOut *midiout = static_cast<RtMidiOut *>(p);
  midiout->openPort(port_index);
}

void midiout_close_port(rtmidi_ptr p) {
  RtMidiOut *midiout = static_cast<RtMidiOut *>(p);
  midiout->closePort();    
}

void midiout_send_message(rtmidi_ptr p, int byte1, int byte2, int byte3) {
  RtMidiOut *midiout = static_cast<RtMidiOut *>(p);
  static std::vector<unsigned char> message(3); // static so we don't keep constructing and destroying objects
  message[0] = byte1;
  message[1] = byte2;
  message[2] = byte3;
  midiout->sendMessage(&message);
}
