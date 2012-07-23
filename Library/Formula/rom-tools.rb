require 'formula'

class RomTools < Formula
  url 'svn://messdev.no-ip.org/mess', :revision => 15603
  head 'svn://messdev.no-ip.org/mess'
  homepage 'http://www.mess.org/'
  version '146u3'

  depends_on :x11
  depends_on 'sdl'

  def install
    ENV['MACOSX_USE_LIBSDL'] = '1'
    ENV['INCPATH'] = '-I./src/lib/util -I/usr/X11/include'
    ENV['PTR64'] = if MacOS.prefer_64_bit? then '1' else '0' end

    system 'make romcmp'
    system 'make jedutil'
    system 'make chdman'
    system 'make tools'

    bin.install ['castool', 'chdman', 'floptool', 'imgtool', 'jedutil',
                 'ldresample', 'ldverify', 'regreg', 'romcmp', 'src2html',
                 'srcclean', 'testkeys', 'unidasm']

    bin.install 'split' => 'rom-split'
  end

  def test
    system "chdman -h"
  end
end

