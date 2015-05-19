class Mlogger < Formula
  desc "Log to syslog from the command-line"
  homepage "https://github.com/nbrownus/mlogger"
  url "https://github.com/nbrownus/mlogger/archive/v1.1.2.tar.gz"
  sha256 "4163687c80b618f3e6c307eeba86cb95097661375cf76c977e8aad1bbc48ee99"

  bottle do
    cellar :any
    sha256 "876a19cf8c72d8d14e08989d7ace12faac1cb9dad3b7406f37c9fe6370b98924" => :yosemite
    sha256 "3b0249322e3cd31e38b1e040c2fa4bc1aa6500461e7582f06d7260dcce77187a" => :mavericks
    sha256 "dd639c0cfb0e5715082cf744d50121b6e735065ea2216abf299b989646843f64" => :mountain_lion
  end

  def install
    system "make"
    bin.install "mlogger"
  end

  test do
    system "mlogger", "-i", "-d", "test"
  end
end
