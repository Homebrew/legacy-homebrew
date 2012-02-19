require 'formula'

class Hatari < Formula
  homepage 'http://hatari.tuxfamily.org'
  url 'http://download.tuxfamily.org/hatari/1.6.1/hatari-1.6.1.tar.bz2'
  md5 '14f6af33734c971cb4f349a38c6981a1'

  depends_on 'cmake' => :build
  depends_on 'sdl'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-osx-bundle"
    system "make install"
  end
end
