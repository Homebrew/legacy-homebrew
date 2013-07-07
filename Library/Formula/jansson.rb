require 'formula'

class Jansson < Formula
  homepage 'http://www.digip.org/jansson/'
  url 'http://www.digip.org/jansson/releases/jansson-2.4.tar.bz2'
  sha1 'f11ff89dd484d89210d9f52a9ccc2ce2b9d2c1ae'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
