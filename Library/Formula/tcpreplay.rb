require "formula"

class Tcpreplay < Formula
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.0.5/tcpreplay-4.0.5.tar.gz"
  sha1 "878970d77e1482c9b26ac19eb2d125915a900f9b"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-dynamic-link"
    system "make", "install"
  end
end
