require 'formula'

class Jed < Formula
  homepage 'http://www.jedsoft.org/jed/'
  url 'ftp://space.mit.edu/pub/davis/jed/v0.99/jed-0.99-19.tar.bz2'
  sha1 '7783ac9035c7221575e74b544902151309d0d0ef'

  depends_on 's-lang'
  depends_on :x11 => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "xjed" if build.with? "x11"

    ENV.deparallelize
    system "make install"
  end
end
