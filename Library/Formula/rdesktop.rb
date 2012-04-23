require 'formula'

class Rdesktop < Formula
  url 'http://downloads.sourceforge.net/project/rdesktop/rdesktop/1.7.1/rdesktop-1.7.1.tar.gz'
  homepage 'http://www.rdesktop.org/'
  md5 'c4b39115951c4a6d74f511c99b18fcf9'

  def install
    ENV.x11
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make install"
  end
end
