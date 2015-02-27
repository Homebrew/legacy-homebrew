class Sha2 < Formula
  homepage "http://www.aarongifford.com/computers/sha.html"
  url "http://www.aarongifford.com/computers/sha2-1.0.1.tgz"
  sha1 "ffbc69e0b0ab47f70e61aeb14fa16ba2b74dc728"

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
