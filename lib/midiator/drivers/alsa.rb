#!/usr/bin/env ruby
#
# The MIDIator driver to interact with ALSA on Linux.
#
# NOTE: as yet completely untested.
#
# == Authors
#
# * Ben Bleything <ben@bleything.net>
#
# == Copyright
#
# Copyright (c) 2008 Ben Bleything
#
# This code released under the terms of the MIT license.
#

require 'midiator'
require 'midiator/driver'
require 'midiator/driver_registry'

class MIDIator::Driver::ALSA < MIDIator::Driver
	module C
      extend DL::Importable
      dlload 'winmm'

      extern "int midiOutOpen( HMIDIOUT*, int, int, int, int )"
      extern "int midiOutClose( int )"
      extern "int midiOutShortMsg( int, int )"
    end

    def open
      @device = DL.malloc( DL.sizeof( 'I' ) )
      C.midiOutOpen( @device, -1, 0, 0, 0 )
    end

    def close
      C.midiOutClose( @device.ptr.to_i )
    end

    def message( one, two=0, three=0 )
      message = one + (two << 8) + (three << 16)
      C.midiOutShortMsg( @device.ptr.to_i, message )
    end
end