require 'formula'

class Libmxml < Formula
  url 'http://ftp.easysw.com/pub/mxml/2.6/mxml-2.6.tar.gz'
  homepage 'http://www.minixml.org/'
  md5 '68977789ae64985dddbd1a1a1652642e'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
