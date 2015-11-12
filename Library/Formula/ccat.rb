class Ccat < Formula
  desc "Like cat but displays content with syntax highlighting"
  homepage "https://github.com/jingweno/ccat"
  url "https://github.com/jingweno/ccat/archive/v1.0.0.tar.gz"
  sha256 "5bd558009a9054ff25f3d023d67080c211354d1552ffe377ce11d49376fb4aee"

  bottle do
    cellar :any_skip_relocation
    sha256 "d516a7d20395e317dd78ad2294aadc55e17c77127ffb15703e699d4fd8c0f027" => :el_capitan
    sha256 "70c3e7597d8c767d83ebaded9056e94221c71aa70f9b79146fc35874959c5655" => :yosemite
    sha256 "201def201539d94334b2cc6fec04154a808d90811352ffeb7d01cd6789e00ccf" => :mavericks
    sha256 "7f31873c0412ff8fa3c04ab70cdb4ecb4f2232c415ca535b6e7b149f166695d1" => :mountain_lion
  end

  conflicts_with "ccrypt", :because => "both install `ccat` binaries"

  depends_on "go" => :build

  def install
    system "./script/build"
    bin.install "ccat"
  end

  test do
    (testpath/"test.txt").write <<-EOS.undent
      I am a colourful cat
    EOS

    assert_match(/I am a colourful cat/, shell_output("#{bin}/ccat test.txt"))
  end
end
