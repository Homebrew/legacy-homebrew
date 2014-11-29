require "formula"

class Align < Formula
  homepage "http://www.cs.indiana.edu/~kinzler/align/"
  url "http://www.cs.indiana.edu/~kinzler/align/align-1.7.4.tgz"
  sha1 "a1dff741a0080252d79b4b4466ca440dc772c7ae"

  bottle do
    cellar :any
    sha1 "b9db933cf1129d4d29245e527feddefeb7e81ada" => :yosemite
    sha1 "524a70b185b3c206d729e13cb2be5b36b50e575b" => :mavericks
    sha1 "ac8557b4df591a67b47fa5d3206f553b8e0393d7" => :mountain_lion
  end

  def install
    system "make", "install", "BINDIR=#{bin}"
  end

  test do
    assert_equal " 1  1\n12 12\n", pipe_output(bin/"align", "1 1\n12 12\n")
  end
end
