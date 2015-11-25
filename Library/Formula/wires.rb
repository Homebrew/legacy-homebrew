class Wires < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/jgraham/wires"
  url "https://github.com/jgraham/wires/archive/v0.4.2.tar.gz"
  sha256 "f86fdac8f69f94bd57dc9fdb45851585a24790b069605d033288e419653c9efe"

  depends_on "rust" => :build

  def install
    system "cargo", "build"
    bin.install "target/debug/wires"
  end

  test do
    system "#{bin}/wires", "--help"
  end

end