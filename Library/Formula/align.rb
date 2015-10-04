class Align < Formula
  desc "Text column alignment filter"
  homepage "http://www.cs.indiana.edu/~kinzler/align/"
  url "http://www.cs.indiana.edu/~kinzler/align/align-1.7.4.tgz"
  sha256 "4775cc92bd7d5d991b32ff360ab74cfdede06c211def2227d092a5a0108c1f03"

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
