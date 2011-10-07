require 'formula'

class Rdesktop < Formula
  url 'http://downloads.sourceforge.net/project/rdesktop/rdesktop/1.6.0/rdesktop-1.6.0.tar.gz'
  homepage 'http://www.rdesktop.org/'
  md5 'c6fcbed7f0ad7e60ac5fcb2d324d8b16'

  def install
    ENV.x11
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make install"
  end
end
