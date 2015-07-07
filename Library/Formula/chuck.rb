class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.3.5.1.tgz"
  sha256 "d141ca61547131edd2b29bdb88183835e4133ef09807674bfa33a4e6e09d1f53"

  bottle do
    cellar :any
    sha1 "08c33bd5071ccbb466fa8347cc034702d1e6fd0b" => :yosemite
    sha1 "513d888da91c755f743693a607075ee4d87b7661" => :mavericks
    sha1 "f9831daea9100f13865049b40057fcec6b6e6203" => :mountain_lion
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
