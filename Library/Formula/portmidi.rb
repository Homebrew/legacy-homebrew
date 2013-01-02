require 'formula'

class Portmidi < Formula
  homepage 'http://sourceforge.net/apps/trac/portmedia/wiki/portmidi'
  url 'http://downloads.sourceforge.net/project/portmedia/portmidi/200/portmidi-src-200.zip'
  sha1 'dcd979881a3b16518d33999e529004d7a647c2db'

  depends_on 'cmake' => :build

  def install
    # PATCH for Snow Leopard, see https://github.com/halfbyte/portmidi
    # hopefully not needed anymore in the next version of portmidi
    architectures = archs_for_command('/bin/sh').join(' ')
    inreplace 'CMakeLists.txt',
      'CMAKE_OSX_ARCHITECTURES i386 ppc CACHE STRING "do not build for 64-bit"',
      "CMAKE_OSX_ARCHITECTURES #{architectures} CACHE STRING \"do only build for required architectures\""

    inreplace 'pm_mac/Makefile.osx', 'PF=/usr/local', "PF=#{prefix}"

    # Fix compilation on Mountain Lion, works on previous versions too
    inreplace 'pm_mac/readbinaryplist.c',
      '#include "Folders.h"',
      '#include <CoreServices/CoreServices.h>'

    # need to create include/lib directories since make won't create them itself
    include.mkpath
    lib.mkpath

    system 'make -f pm_mac/Makefile.osx'
    system 'make -f pm_mac/Makefile.osx install'
  end
end
