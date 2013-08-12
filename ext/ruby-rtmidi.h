extern "C"
{
  typedef void * rtmidi_ptr;

  //================================================
  // INPUT

  rtmidi_ptr midiin_new();

  void midiin_delete(rtmidi_ptr midiin);

  int midiin_port_count(rtmidi_ptr midiin);

  const char * midiin_port_name(rtmidi_ptr midiin, int port_index);

  void midiin_open_port(rtmidi_ptr p, int port_index);

  void midiin_close_port(rtmidi_ptr p);


  //================================================
  // OUTPUT

  rtmidi_ptr midiout_new();

  void midiout_delete(rtmidi_ptr midiout);

  int midiout_port_count(rtmidi_ptr midiout);

  const char * midiout_port_name(rtmidi_ptr midiout, int port_index);

  void midiout_open_port(rtmidi_ptr p, int port_index);

  void midiout_close_port(rtmidi_ptr p);

  void midiout_send_message(rtmidi_ptr p, int byte1, int byte2, int byte3);
};
