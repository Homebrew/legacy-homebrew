class Aget < Formula
  desc "Multithreaded HTTP download accelerator"
  homepage "http://www.enderunix.org/aget/"
  url "http://www.enderunix.org/aget/aget-0.4.1.tar.gz"
  sha256 "d17393c7f44aab38028ae71f14b572ba1839b6e085fb2092b6ebe68bc931df4d"
  head "https://github.com/EnderUNIX/Aget.git"

  bottle do
    cellar :any
    sha1 "62c6fbd2f84ce88cd4c10f7faf48f4436c2addde" => :yosemite
    sha1 "7949a392886fe34408669c529af6697b96acafc9" => :mavericks
    sha1 "2b6c73f112e7aedd05807c61e118a32a057cd5f7" => :mountain_lion
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
