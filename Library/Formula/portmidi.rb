require 'formula'

class Portmidi <Formula
  url 'http://downloads.sourceforge.net/project/portmedia/portmidi/200/portmidi-src-200.zip'
  homepage 'http://sourceforge.net/apps/trac/portmedia/wiki/portmidi'
  md5 '26053a105d938395227bb6ae1d78643b'

  depends_on 'cmake'

  def caveats
    <<-EOS.undent
      NOTE: "brew install -v portmidi" will fail! You must install
      in non-verbose mode for this to succeed.
    EOS
  end

  def install
    # PATCH for Snow Leopard, see http://github.com/halfbyte/portmidi
    # hopefully not needed anymymore in the next version of portmidi
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
