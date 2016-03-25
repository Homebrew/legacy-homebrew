class Sha2 < Formula
  desc "Implementation of SHA-256, SHA-384, and SHA-512 hash algorithms"
  homepage "http://aarongifford.com/computers/sha.html"
  url "https://aarongifford.com/computers/sha2-1.0.1.tgz"
  sha256 "67bc662955c6ca2fa6a0ce372c4794ec3d0cd2c1e50b124e7a75af7e23dd1d0c"

  bottle do
    cellar :any_skip_relocation
    revision 3
    sha256 "84ce281185ba415257d8507e9b16ba8dc3189ec8b8414d21a6421d5979a025d2" => :el_capitan
    sha256 "da63b7e9be95c91bcdc3290e3c6caee12016c5d59960144ea26f8c6438dfe680" => :yosemite
    sha256 "34650fbb427aa57f452acc23a338696756792907bd7e127d7b495a7fd7e4573a" => :mavericks
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
