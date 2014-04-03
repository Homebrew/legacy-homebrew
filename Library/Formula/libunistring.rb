require 'formula'

class Libunistring < Formula
  homepage 'http://www.gnu.org/software/libunistring/'
  url 'http://ftpmirror.gnu.org/libunistring/libunistring-0.9.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libunistring/libunistring-0.9.3.tar.gz'
  sha1 'e1ea13c24a30bc93932d19eb5ad0704a618506dd'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
