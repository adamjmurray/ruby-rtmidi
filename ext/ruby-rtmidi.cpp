#include "RtMidi.h"
#include "RtError.h"
#include <vector>
#include <cstring>
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
  std::string name = midiin->getPortName(port_index);
  // std::string will be freed from memory at end of scope, so copy into a c string before returning
  // NOTE: this creates a small memory leak but shouldn't be a problem in practice?
  char * cstr = new char [name.length()+1];
  std::strcpy(cstr, name.c_str());
  return cstr;
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

void midiin_callback_proxy( double deltatime, std::vector< unsigned char > *message, void *userData )
{
  unsigned int byte_count = message->size();
  // for ( unsigned int i=0; i<byte_count; i++ )
  //   std::cout << "Byte " << i << " = " << (int)message->at(i) << ", ";
  // if ( byte_count > 0 )
  //   std::cout << "stamp = " << deltatime << std::endl; # TODO: do we care about the deltatime?
  int byte1 = 0, byte2 = 0, byte3 = 0;
  if(byte_count > 0) byte1 = (int)message->at(0);
  if(byte_count > 1) byte2 = (int)message->at(1);
  if(byte_count > 2) byte3 = (int)message->at(2);
  ((rtmidi_callback)userData)(byte1, byte2, byte3);
}

void midiin_set_callback(rtmidi_ptr p, rtmidi_callback callback) {
  RtMidiIn *midiin = static_cast<RtMidiIn *>(p);
  midiin->setCallback(midiin_callback_proxy, (void *)callback);
}

void midiin_cancel_callback(rtmidi_ptr p) {
  RtMidiIn *midiin = static_cast<RtMidiIn *>(p);
  midiin->cancelCallback();
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
  std::string name = midiout->getPortName(port_index);
  // std::string will be freed from memory at end of scope, so copy into a c string before returning
  // NOTE: this creates a small memory leak but shouldn't be a problem in practice?
  char * cstr = new char [name.length()+1];
  std::strcpy(cstr, name.c_str());
  return cstr;
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
