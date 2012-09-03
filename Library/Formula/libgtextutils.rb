require 'formula'

class Libgtextutils < Formula
  homepage 'http://hannonlab.cshl.edu/fastx_toolkit/'
  url 'http://hannonlab.cshl.edu/fastx_toolkit/libgtextutils-0.6.tar.bz2'
  sha1 '0e3ad375249d7f5236d18285e8a84141e118b119'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
