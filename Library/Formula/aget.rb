require "formula"

class Aget < Formula
  homepage "http://www.enderunix.org/aget/"
  url "http://www.enderunix.org/aget/aget-0.4.1.tar.gz"
  sha256 "d17393c7f44aab38028ae71f14b572ba1839b6e085fb2092b6ebe68bc931df4d"
  head "https://github.com/EnderUNIX/Aget.git"

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
