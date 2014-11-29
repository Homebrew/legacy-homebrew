require "formula"

class Align < Formula
  homepage "http://www.cs.indiana.edu/~kinzler/align/"
  url "http://www.cs.indiana.edu/~kinzler/align/align-1.7.4.tgz"
  sha1 "a1dff741a0080252d79b4b4466ca440dc772c7ae"

  bottle do
    cellar :any
    sha1 "6883eab5710385e8890fb52a8a6ac248f6bb29b7" => :mavericks
    sha1 "12b51ccae39d06623f7475e289fd6eb6dbb89d7f" => :mountain_lion
    sha1 "58e739c1df5c04ef37303c822fd4c859bf9e89eb" => :lion
  end

  def install
    system "make", "install", "BINDIR=#{bin}"
  end

  test do
    assert_equal " 1  1\n12 12\n", pipe_output(bin/"align", "1 1\n12 12\n")
  end
end
