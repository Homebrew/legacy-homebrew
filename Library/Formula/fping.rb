require "formula"

class Fping < Formula
  homepage "http://fping.org/"
  url "http://fping.org/dist/fping-3.10.tar.gz"
  sha1 "d8a1fa3ec13289d67d70102c1ef16c461a7eb505"

  head "https://github.com/schweikert/fping.git"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--enable-ipv6"
    system "make install"
  end

end
