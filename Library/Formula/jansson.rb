require 'formula'

class Jansson < Formula
  homepage 'http://www.digip.org/jansson/'
  url 'http://www.digip.org/jansson/releases/jansson-2.3.1.tar.bz2'
  sha1 'af7497d930423088fa6d0699d84740fffa0c98df'

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
