require 'formula'

class Portmidi < Formula
  homepage 'http://sourceforge.net/apps/trac/portmedia/wiki/portmidi'
  url 'http://downloads.sourceforge.net/project/portmedia/portmidi/200/portmidi-src-200.zip'
  md5 '26053a105d938395227bb6ae1d78643b'

  depends_on 'cmake' => :build

  def install
    # PATCH for Snow Leopard, see https://github.com/halfbyte/portmidi
    # hopefully not needed anymore in the next version of portmidi
    architectures = archs_for_command('/bin/sh').join(' ')
    inreplace 'CMakeLists.txt',
      'CMAKE_OSX_ARCHITECTURES i386 ppc CACHE STRING "do not build for 64-bit"',
      "CMAKE_OSX_ARCHITECTURES #{architectures} CACHE STRING \"do only build for required architectures\""

    inreplace 'pm_mac/Makefile.osx', 'PF=/usr/local', "PF=#{prefix}"

    # need to create include/lib directories since make won't create them itself
    include.mkpath
    lib.mkpath

    system 'make -f pm_mac/Makefile.osx'
    system 'make -f pm_mac/Makefile.osx install'
  end
end
