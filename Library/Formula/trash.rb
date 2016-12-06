require "formula"

class Trash < Formula
  homepage "https://github.com/samuelkadolph/trash"
  url "https://github.com/samuelkadolph/trash/tarball/v1.0.0"
  sha1 "ab3298f330aedf80e734d2979e26f9dcbf6e3fa5"

  head "https://github.com/samuelkadolph/trash"

  def install
    system "make"
    bin.install "build/release/trash"
  end
end
