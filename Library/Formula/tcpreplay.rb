require "formula"

class Tcpreplay < Formula
  homepage "http://tcpreplay.appneta.com"
  url "https://downloads.sourceforge.net/project/tcpreplay/tcpreplay/4.0.4/tcpreplay-4.0.4.tar.gz"
  sha1 "f2f266508b06693852bbc5003b20b18da4a1f01b"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-dynamic-link"
    system "make", "install"
  end
end
