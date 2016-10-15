require "formula"

class Zlib < Formula
  homepage "http://www.zlib.net"
  url "http://zlib.net/zlib-1.2.8.tar.xz"
  sha1 "b598beb7acc96347cbd1020b71aef7871d374677"

  def install
    system "./configure", "--prefix=#{prefix}"

    system "make", "install"
  end
end

