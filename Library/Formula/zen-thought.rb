require "formula"

class ZenThought < Formula
  homepage "https://github.com/dpapathanasiou/zen-thought"
  url "https://github.com/dpapathanasiou/zen-thought/archive/master.tar.gz"
  sha1 "50ebca5395cfdc202d5b8c73a76a9841a27474f8"
  version "master"

  def install
    system "make all"
    bin.install "zen-thought"
  end
end
