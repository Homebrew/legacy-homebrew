require 'formula'

class Vorbisgain <Formula
  url 'http://freshmeat.net/urls/e251f5bf2d45abfdc2c44540b46e37c0'
  homepage 'http://sjeng.org/vorbisgain.html'
  md5 '3c9df5028fa395aa98fdf0f58a5187b0'
  version '0.36'

  depends_on 'libvorbis'
  depends_on 'libogg'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
