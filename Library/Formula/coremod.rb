require "formula"

class Coremod < Formula
  homepage "http://xmp.sourceforge.net"
  url "https://github.com/cmatsuoka/coremod/archive/coremod-4.2.7.tar.gz"
  sha1 "228ed11a202476aa09ff1ba7b5c4148982a96668"

  head "https://github.com/cmatsuoka/coremod.git"

  depends_on "autoconf" => :build

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
