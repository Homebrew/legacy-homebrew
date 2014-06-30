require 'formula'

class Jansson < Formula
  homepage 'http://www.digip.org/jansson/'
  url 'http://www.digip.org/jansson/releases/jansson-2.6.tar.gz'
  sha1 '70ff0bf10db63850e5d26327d1e9fd8a58d608e4'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
