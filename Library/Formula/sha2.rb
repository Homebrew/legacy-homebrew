class Sha2 < Formula
  desc "Implementation of SHA-256, SHA-384, and SHA-512 hash algorithms"
  homepage "http://aarongifford.com/computers/sha.html"
  url "http://aarongifford.com/computers/sha2-1.0.1.tgz"
  sha256 "67bc662955c6ca2fa6a0ce372c4794ec3d0cd2c1e50b124e7a75af7e23dd1d0c"

  bottle do
    cellar :any
    revision 1
    sha256 "e087ba4357e2ed9d75bd2d25253c0982ac742db854d1c7c6792671d58e05bdc8" => :yosemite
    sha256 "7bb393c6de372210c1343a76094063a344f59f7bfeed67210abc749e9dfb93aa" => :mavericks
    sha256 "dc28fabf8cd4680b5ff534de7ef19ad95c4b839f6b891f80292e6ac9bd0952ad" => :mountain_lion
  end

  option "without-test", "Skip compile-time tests"

  deprecated_option "without-check" => "without-test"

  def install
    system ENV.cc, "-o", "sha2", "sha2prog.c", "sha2.c"
    system "perl", "sha2test.pl" if build.with? "test"
    bin.install "sha2"
  end

  test do
    (testpath/"checkme.txt").write "homebrew"
    output = "12c87370d1b5472793e67682596b60efe2c6038d63d04134a1a88544509737b4"
    assert_match output, pipe_output("#{bin}/sha2 -q -256 #{testpath}/checkme.txt")
  end
end
