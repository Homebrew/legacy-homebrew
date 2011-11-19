require 'formula'

class Cunit < Formula
  url 'http://downloads.sourceforge.net/project/cunit/CUnit/2.1-2/CUnit-2.1-2-src.tar.bz2'
  homepage 'http://cunit.sourceforge.net/'
  version '2.1-2'
  md5 '31c62bd7a65007737ba28b7aafc44d3a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
