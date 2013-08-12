extern "C"
{
  typedef void * rtmidi_ptr;

  rtmidi_ptr new_midiin();

  void delete_midiin(rtmidi_ptr midiin);

  int midiin_port_count(rtmidi_ptr midiin);

  const char * midiin_port_name(rtmidi_ptr midiin, int port_index);


  rtmidi_ptr new_midiout();

  void delete_midiout(rtmidi_ptr midiout);

  int midiout_port_count(rtmidi_ptr midiout);

  const char * midiout_port_name(rtmidi_ptr midiout, int port_index);
};
