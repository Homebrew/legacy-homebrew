class Wires < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/jgraham/wires"
  url "https://github.com/jgraham/wires/archive/v0.4.2.tar.gz"
  sha256 "f86fdac8f69f94bd57dc9fdb45851585a24790b069605d033288e419653c9efe"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b58c4a03483a791a67a3883ebb07b70c0e16a125d3424f20a299bb2c25f50ab" => :el_capitan
    sha256 "1bbcdac65c0d297932d132e16ee09753d6c0ae2eaa98d1a124a23eab50486d52" => :yosemite
    sha256 "cd4173ade452891eae61ef95480abd45cf84cd1716ad8d603e30e10bce356c3b" => :mavericks
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build"
    bin.install "target/debug/wires"
  end

  test do
    system "#{bin}/wires", "--help"
  end
end
