require 'formula'

class Ume < Formula
  homepage 'http://mamedev.org/'
  url 'svn://dspnet.fr/mame/trunk', :revision => '20928'
  version '0.148u1'

  head 'svn://dspnet.fr/mame/trunk'

  depends_on :x11
  depends_on 'sdl'

  def install
    ENV['MACOSX_USE_LIBSDL'] = '1'
<<<<<<< HEAD
    ENV['INCPATH'] = "-I./src/lib/util -I#{MacOS::XQuartz.include}"
=======
    ENV['INCPATH'] = "-I./src/lib/util -I#{MacOS::X11.include}"
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    ENV['PTR64'] = (MacOS.prefer_64_bit? ? '1' : '0')

    system 'make', 'TARGET=ume'

    if MacOS.prefer_64_bit?
      bin.install 'ume64' => 'ume'
    else
      bin.install 'ume'
    end
  end
end
