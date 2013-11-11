#ifdef __RUBY_RTMIDI_DLL__
  #define DLL_EXPORT __declspec( dllexport ) // export function definitions for Windows DLL compiled via cl.exe
#else
  #define DLL_EXPORT
#endif

extern "C"
{
  typedef void* rtmidi_ptr;
  typedef void (*rtmidi_callback)(int byte1, int byte2, int byte3);

  //================================================
  // INPUT

  DLL_EXPORT rtmidi_ptr midiin_new();

  DLL_EXPORT void midiin_delete(rtmidi_ptr midiin);

  DLL_EXPORT int midiin_port_count(rtmidi_ptr midiin);

  DLL_EXPORT const char* midiin_port_name(rtmidi_ptr midiin, int port_index);

  DLL_EXPORT void midiin_open_port(rtmidi_ptr p, int port_index);

  DLL_EXPORT void midiin_close_port(rtmidi_ptr p);

  DLL_EXPORT void midiin_ignore_types(rtmidi_ptr p, bool sysex, bool timing, bool active_sensing);

  DLL_EXPORT void midiin_set_callback(rtmidi_ptr p, rtmidi_callback callback);

  DLL_EXPORT void midiin_cancel_callback(rtmidi_ptr p);
  

  //================================================
  // OUTPUT

  DLL_EXPORT rtmidi_ptr midiout_new();

  DLL_EXPORT void midiout_delete(rtmidi_ptr midiout);

  DLL_EXPORT int midiout_port_count(rtmidi_ptr midiout);

  DLL_EXPORT const char* midiout_port_name(rtmidi_ptr midiout, int port_index);

  DLL_EXPORT void midiout_open_port(rtmidi_ptr p, int port_index);

  DLL_EXPORT void midiout_close_port(rtmidi_ptr p);

  DLL_EXPORT void midiout_send_message(rtmidi_ptr p, int byte1, int byte2, int byte3);
};
