require "formula"

class Chuck < Formula
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.3.4.0.tgz"
  sha1 "d32faae2cb60fc81d2716b477cf2d54bc548d9c6"

  def install
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    (share/"chuck").install "examples"
  end
end
