extern "C"
{
  typedef void * rtmidi_ptr;

  rtmidi_ptr new_midiin();

  void delete_midiin(rtmidi_ptr midiin);

  void print_inputs(rtmidi_ptr midiin);


  rtmidi_ptr new_midiout();

  void delete_midiout(rtmidi_ptr midiout);

  void print_outputs(rtmidi_ptr midiout);

};
