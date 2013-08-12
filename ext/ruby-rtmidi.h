extern "C"
{
  typedef void * rtmidi_ptr;

  rtmidi_ptr create_midiin();

  void print_inputs(rtmidi_ptr p);
};
