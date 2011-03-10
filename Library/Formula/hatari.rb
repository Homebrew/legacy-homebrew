require 'formula'

class Hatari < Formula
  url 'http://download.berlios.de/hatari/hatari-1.4.0.tar.bz2'
  homepage 'http://hatari.berlios.de/'
  md5 '2f30e5c9e146ee92e3f2f5ae1cef3673'

  depends_on 'cmake' => :build
  depends_on 'sdl'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--disable-osx-bundle"
    system "make install"
  end
end
