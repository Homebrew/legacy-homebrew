require "formula"

class LibatomicOps < Formula
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-7.4.2.tar.gz"
  sha1 "57cd7c64e37fca300bd7b24e3d2f14129b25b376"

  bottle do
    cellar :any
    sha1 "3027c1a78e217eaae84c750897590002e85f19b7" => :mavericks
    sha1 "c077b08a1bef2d36af10f50140e4a4891ec7a9bc" => :mountain_lion
    sha1 "2fea667e556aec2efa27f64c9bdd4f54d09048dc" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
