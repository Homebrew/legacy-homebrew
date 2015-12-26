class Ccat < Formula
  desc "Like cat but displays content with syntax highlighting"
  homepage "https://github.com/jingweno/ccat"
  url "https://github.com/jingweno/ccat/archive/v1.1.0.tar.gz"
  sha256 "b02d2c8d573f5d73595657c7854c9019d3bd2d9e6361b66ce811937ffd2bfbe1"

  bottle do
    cellar :any_skip_relocation
    sha256 "10eb7df98a05c968f006bbda2c6f690bd7d5053e4bb6d2c9c4a043616648a23b" => :el_capitan
    sha256 "063b4cab434b5d16e8884aad6eb7d18068c33f9ec884fabf5ada3ad821428897" => :yosemite
    sha256 "04342b5be5ffffaa696799b006b592cad530b0fcd510514ad9c72bc70c5865ba" => :mavericks
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
