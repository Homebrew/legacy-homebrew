require "formula"

class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-7.4.2.tar.gz"
  sha1 "57cd7c64e37fca300bd7b24e3d2f14129b25b376"

  bottle do
    cellar :any
    revision 1
    sha1 "5820ac7413428e5a0ade9b34cb3394b2abddfd58" => :yosemite
    sha1 "b314405de1ecda4e8ee8082443b642f1a4b11ae6" => :mavericks
    sha1 "7dbd87d8daef4b8a91397f07091323f2a2580b3b" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
