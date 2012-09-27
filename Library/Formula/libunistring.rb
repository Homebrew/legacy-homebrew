require 'formula'

class Libunistring < Formula
  url 'http://ftpmirror.gnu.org/libunistring/libunistring-0.9.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libunistring/libunistring-0.9.3.tar.gz'
  homepage 'http://www.gnu.org/software/libunistring/'
  sha1 'e1ea13c24a30bc93932d19eb5ad0704a618506dd'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
