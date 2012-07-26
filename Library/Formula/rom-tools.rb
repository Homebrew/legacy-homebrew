require 'formula'

class RomTools < Formula
  homepage 'http://www.mess.org/'
  url 'svn://messdev.no-ip.org/mess', :revision => 15603
  version '146u3'

  head 'svn://messdev.no-ip.org/mess'

  depends_on :x11
  depends_on 'sdl'

  def install
    ENV['MACOSX_USE_LIBSDL'] = '1'
    ENV['INCPATH'] = "-I./src/lib/util -I#{MacOS::XQuartz.include}"
    ENV['PTR64'] = (MacOS.prefer_64_bit? ? '1' : '0')

    system 'make romcmp'
    system 'make jedutil'
    system 'make chdman'
    system 'make tools'

    bin.install %W[
      castool chdman floptool imgtool jedutil ldresample ldverify regreg
      romcmp src2htm srcclean testkeys unidasm'
    ]
    bin.install 'split' => 'rom-split'
  end
end
