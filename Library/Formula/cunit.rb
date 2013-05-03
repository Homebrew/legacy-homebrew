require 'formula'

class Cunit < Formula
  homepage 'http://cunit.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cunit/CUnit/2.1-2/CUnit-2.1-2-src.tar.bz2'
  sha1 '6c2d0627eb64c09c7140726d6bf814cf531a3ce0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
