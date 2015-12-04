class Aget < Formula
  desc "Multithreaded HTTP download accelerator"
  homepage "http://www.enderunix.org/aget/"
  url "http://www.enderunix.org/aget/aget-0.4.1.tar.gz"
  sha256 "d17393c7f44aab38028ae71f14b572ba1839b6e085fb2092b6ebe68bc931df4d"
  head "https://github.com/EnderUNIX/Aget.git"

  bottle do
    cellar :any
    sha256 "50eeae036e0d440673b98a1952992d10d8d7f67fca0ed7424b295606b86d33de" => :yosemite
    sha256 "ec1c185478a302af5644b494dd82cf162947b3f389e1125dcaae25b00b2259c3" => :mavericks
    sha256 "e13906227621a18d8c3ea3bfa3fd164ab82a398f3d556557d786c7a7899d36c2" => :mountain_lion
  end

  def install
    # ENV replaces the MacPorts patch that ensured compile on OS X.
    # https://github.com/EnderUNIX/Aget/issues/3
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install "aget"
    man1.install "aget.1"
  end
end
