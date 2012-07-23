require 'formula'

class Mame < Formula
  homepage 'http://mamedev.org/'
  url 'svn://messdev.no-ip.org/mess', :revision => 15603
  version '146u3'

  head 'svn://messdev.no-ip.org/mess'

  depends_on :x11
  depends_on 'sdl'

  def install
    ENV['MACOSX_USE_LIBSDL'] = '1'
    ENV['INCPATH'] = "-I./src/lib/util -I#{MacOS.x11_prefix}/include"
    ENV['PTR64'] = (MacOS.prefer_64_bit? ? '1' : '0')

    system 'make', 'TARGET=mame', 'SUBTARGET=mame'

    if MacOS.prefer_64_bit?
      bin.install 'mame64' => 'mame'
    else
      bin.install 'mame'
    end
  end
end
