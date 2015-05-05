class Sha2 < Formula
  homepage "https://www.aarongifford.com/computers/sha.html"
  url "https://www.aarongifford.com/computers/sha2-1.0.1.tgz"
  sha256 "67bc662955c6ca2fa6a0ce372c4794ec3d0cd2c1e50b124e7a75af7e23dd1d0c"

  bottle do
    cellar :any
    sha1 "df93015804de4b208f7eb7c3e6ea390aa4839da0" => :yosemite
    sha1 "6a70d9dab98a22b03aa83b735746c356fcfd4ced" => :mavericks
    sha1 "23658e75f2a245c7fbcb63d792db85a5b8c9d5c0" => :mountain_lion
  end

  option "without-check", "Skip compile-time tests"

  def install
    system ENV.cc, "-o", "sha2", "sha2prog.c", "sha2.c"
    system "perl", "sha2test.pl" if build.with? "check"
    bin.install "sha2"
  end

  test do
    (testpath/"checkme.txt").write("homebrew")
    output = pipe_output("#{bin}/sha2 -q -256 #{testpath}/checkme.txt")
    expected = "12c87370d1b5472793e67682596b60efe2c6038d63d04134a1a88544509737b4"
    assert output.include? expected
  end
end
