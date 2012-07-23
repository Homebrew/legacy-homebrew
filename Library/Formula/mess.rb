require 'formula'

class Mess < Formula
  url 'svn://messdev.no-ip.org/mess', :revision => 15603
  head 'svn://messdev.no-ip.org/mess'
  homepage 'http://www.mess.org/'
  version '146u3'

  depends_on :x11
  depends_on 'sdl'

  def install
    ENV['MACOSX_USE_LIBSDL'] = '1'
    ENV['INCPATH'] = '-I./src/lib/util -I/usr/X11/include'
    ENV['PTR64'] = if MacOS.prefer_64_bit? then '0' else '1' end

    system 'make' # Builds MESS
    if MacOS.prefer_64_bit?
      bin.install 'mess64' => 'mess'
    else
      bin.install 'mess'
    end
  end

  def test
    system "mess -h"
  end
end
