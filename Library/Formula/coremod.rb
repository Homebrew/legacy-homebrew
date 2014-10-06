require "formula"

class Coremod < Formula
  homepage "http://xmp.sourceforge.net"
  url "https://github.com/cmatsuoka/coremod/archive/coremod-4.2.8.tar.gz"
  sha1 "583cb3bdc6df583739c5b44a4961ba364e0b0ecd"

  head "https://github.com/cmatsuoka/coremod.git"

  depends_on "autoconf" => :build

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
