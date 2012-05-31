require 'formula'

class Libunistring < Formula
  url 'http://ftpmirror.gnu.org/libunistring/libunistring-0.9.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libunistring/libunistring-0.9.3.tar.gz'
  homepage 'http://www.gnu.org/software/libunistring/'
  md5 'db8eca3b64163abadf8c40e5cecc261f'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
