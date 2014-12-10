require "formula"

class Pngpaste < Formula
  homepage "https://github.com/jcsalterego/pngpaste"
  url "https://github.com/jcsalterego/pngpaste/archive/0.2.1.tar.gz"
  sha1 "33a8327365eacc862ec7cb25cc15c445d79d6d42"

  def install
    system "make", "all"
    bin.install "pngpaste"
  end
end
