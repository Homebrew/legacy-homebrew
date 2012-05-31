require 'formula'

class Jansson < Formula
  url 'http://www.digip.org/jansson/releases/jansson-2.3.tar.gz'
  homepage 'http://www.digip.org/jansson/'
  md5 '17d92cb6200cc06d8403134cb37ad2b8'

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
