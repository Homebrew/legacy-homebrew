require 'formula'

class Mame < Formula
  homepage 'http://mamedev.org/'
  #url 'http://git.redump.net/mame', :revision => 15603
  url 'http://mamedev.org/downloader.php?file=releases/mame0147s.zip'
  version '0147s'
  sha1 '023a5841389ae8d41db21704cffdeedb258591e9'

  depends_on :x11
  depends_on 'sdl'

  def install
    ENV['MACOSX_USE_LIBSDL'] = '1'
    ENV['INCPATH'] = "-I./src/lib/util -I#{MacOS::X11.include}"
    ENV['PTR64'] = (MacOS.prefer_64_bit? ? '1' : '0')

    system 'unzip mame.zip'
    system 'make', 'TARGET=mame', 'SUBTARGET=mame'

    if MacOS.prefer_64_bit?
      bin.install 'mame64' => 'mame'
    else
      bin.install 'mame'
    end
  end
end
