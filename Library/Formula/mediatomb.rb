require 'formula'

class Mediatomb < Formula
  url 'http://downloads.sourceforge.net/mediatomb/mediatomb-0.12.1.tar.gz'
  homepage 'http://mediatomb.cc'
  md5 'e927dd5dc52d3cfcebd8ca1af6f0d3c2'

  def install
    system "curl https://launchpadlibrarian.net/71985647/libav_0.7_support.patch|patch -p1"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
