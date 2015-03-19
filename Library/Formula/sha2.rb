class Sha2 < Formula
  homepage "http://www.aarongifford.com/computers/sha.html"
  url "http://www.aarongifford.com/computers/sha2-1.0.1.tgz"
  sha1 "ffbc69e0b0ab47f70e61aeb14fa16ba2b74dc728"

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
