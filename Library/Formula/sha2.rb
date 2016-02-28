class Sha2 < Formula
  desc "Implementation of SHA-256, SHA-384, and SHA-512 hash algorithms"
  homepage "http://aarongifford.com/computers/sha.html"
  url "https://aarongifford.com/computers/sha2-1.0.1.tgz"
  sha256 "67bc662955c6ca2fa6a0ce372c4794ec3d0cd2c1e50b124e7a75af7e23dd1d0c"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "721c7f6b1f503e76394f6bd63f6305f45e310a94c245e3f53c82d64c44004c13" => :el_capitan
    sha256 "6609d4da8235a23b7e777d93b6e3db097c706daff289219ac3137635d7e9445f" => :yosemite
    sha256 "3f6742fa3405ab5fb30ddbe09007965dc9836f95ff9e02508f3fef610ad0a29d" => :mavericks
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
