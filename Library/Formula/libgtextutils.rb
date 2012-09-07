require 'formula'

class Libgtextutils < Formula
  homepage 'http://hannonlab.cshl.edu/fastx_toolkit/'
  url 'http://hannonlab.cshl.edu/fastx_toolkit/libgtextutils-0.6.1.tar.bz2'
  sha1 'dbf1714be75511feae3313904a7449a1f680bc23'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
