class Align < Formula
  desc "Text column alignment filter"
  homepage "https://www.cs.indiana.edu/~kinzler/align/"
  url "https://www.cs.indiana.edu/~kinzler/align/align-1.7.5.tgz"
  sha256 "cc692fb9dee0cc288757e708fc1a3b6b56ca1210ca181053a371cb11746969dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2c177c8be3b5a58e60f3a1f39d9fdd3cc3d39247d92be45142cd06ae80273bf" => :el_capitan
    sha256 "caa9e8c3b3a9d946b95d5222b1518c5307499d57fe17f593ec3911f9cc6eace7" => :yosemite
    sha256 "f903cb30e079f56c5743e2ca22a168c61d7a7c57b2cf6bc3c6492ed214a296a3" => :mavericks
  end

  conflicts_with "speech-tools", :because => "both install `align` binaries"

  def install
    system "make", "install", "BINDIR=#{bin}"
  end

  test do
    assert_equal " 1  1\n12 12\n", pipe_output(bin/"align", "1 1\n12 12\n")
  end
end
