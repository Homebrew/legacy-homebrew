require 'formula'

class Hatari < Formula
  url 'http://download.berlios.de/hatari/hatari-1.5.0.tar.bz2'
  homepage 'http://hatari.berlios.de/'
  md5 '16277cff73ec3a342b87b7b7ea3932f4'

  depends_on 'cmake' => :build
  depends_on 'sdl'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--disable-osx-bundle"
    system "make install"
  end
end
