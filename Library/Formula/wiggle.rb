require 'formula'

class Wiggle < Formula
  homepage "http://neil.brown.name/blog/20100324064620"
  url "http://neil.brown.name/wiggle/wiggle-1.0.tar.gz"
  sha1 "07fa4450c658d3f24d2e529b7fc4d883b5ba2e51"

  # All three patches are upstream commits
  patch do
    url "https://github.com/neilbrown/wiggle/commit/16bb4be1c93be24917669d63ab68dd7d77597b63.diff"
    sha1 "9d3b4a0ebdb8e1fbd6f50c906255d72b78f957fd"
  end

  patch do
    url "https://github.com/neilbrown/wiggle/commit/e010f2ffa78b0e50eff5a9e664f9de27bb790035.diff"
    sha1 "c0156c25768b8d9f5ffbfde47b066aecc579c0ec"
  end

  patch do
    url "https://github.com/neilbrown/wiggle/commit/351535d3489f4583a49891726616375e249ab1f3.diff"
    sha1 "cfb18a814285dc6705997846f51bdc1ace02015b"
  end

  def install
    system "make", "OptDbg=#{ENV.cflags}", "wiggle", "wiggle.man", "test"
    bin.install "wiggle"
    man1.install "wiggle.1"
  end
end
