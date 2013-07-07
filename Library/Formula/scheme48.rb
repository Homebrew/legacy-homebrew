require 'formula'

class Scheme48 < Formula
  homepage 'http://www.s48.org/'
  url 'http://s48.org/1.9/scheme48-1.9.tgz'
  sha1 '8fd78d328a8c39ecd848e849ade094c30c2bb4ba'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gc=bibop"
    system "make"
    system "make install"
  end
end
