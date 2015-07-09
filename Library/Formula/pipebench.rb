class Pipebench < Formula
  desc "Measure the speed of STDIN/STDOUT communication"
  homepage "http://www.habets.pp.se/synscan/programs.php?prog=pipebench"
  # Upstream server behaves oddly: https://github.com/Homebrew/homebrew/issues/40897
  # url "http://www.habets.pp.se/synscan/files/pipebench-0.40.tar.gz"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/pipebench/pipebench_0.40.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/pipebench/pipebench_0.40.orig.tar.gz"
  sha256 "ca764003446222ad9dbd33bbc7d94cdb96fa72608705299b6cc8734cd3562211"

  bottle do
    cellar :any
    sha256 "a999c7ba2978e60d38bdeec63d1f1a8b2667cb0d77d35c4da2e57212a37b85ac" => :yosemite
    sha256 "c5b0805588d8a8d9047d30b9330dd0be0215bfe694ed662cf11fa84595bba85c" => :mavericks
    sha256 "217b9b59e5592718c530e4843cb0dfdc830f9f8fc175766abfd3cade97c66c80" => :mountain_lion
  end

  def install
    system "make"
    bin.install "pipebench"
    man1.install "pipebench.1"
  end

  test do
    system "#{bin}/pipebench", "-h"
  end
end
