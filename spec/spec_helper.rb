require 'ffi'

# stub out ffi for tests
module FFI::Library
  def ffi_lib(*args)
  end
  def attach_function(*args)
  end
end

require 'rtmidi'