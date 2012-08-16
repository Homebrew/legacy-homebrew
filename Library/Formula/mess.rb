require 'formula'

class Mess < Formula
  homepage 'http://www.mess.org/'
  url 'svn://messdev.no-ip.org/mess', :revision => 15603
  version '146u3'

  head 'svn://messdev.no-ip.org/mess'

  depends_on :x11
  depends_on 'sdl'

  def install
    ENV['MACOSX_USE_LIBSDL'] = '1'
    ENV['INCPATH'] = "-I./src/lib/util -I#{MacOS::X11.include}"
    ENV['PTR64'] = (MacOS.prefer_64_bit? ? '1' : '0')

    system 'make'

    if MacOS.prefer_64_bit?
      bin.install 'mess64' => 'mess'
    else
      bin.install 'mess'
    end
  end
end
