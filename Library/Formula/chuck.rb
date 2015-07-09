class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.3.5.1.tgz"
  sha256 "d141ca61547131edd2b29bdb88183835e4133ef09807674bfa33a4e6e09d1f53"

  bottle do
    cellar :any
    sha256 "a7f640aafbc973549793d18e388ac0d95c7ce8380f4fc779796bf0d3bb13ffc1" => :yosemite
    sha256 "b0b9b98854278972e15ec803ba506756b3baf3049d8b625b5a698277c0be0782" => :mavericks
    sha256 "d5f7372ca9f939763a4ffd3894d8384797417cdb3455899f80da0f188c84f812" => :mountain_lion
  end

  def install
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    (share/"chuck").install "examples"
  end

  test do
    assert_match /probe \[success\]/m, shell_output("#{bin}/chuck --probe 2>&1")
  end
end
