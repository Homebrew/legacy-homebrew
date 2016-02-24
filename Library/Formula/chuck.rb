class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.3.5.2.tgz"
  sha256 "e900b8545ffcb69c6d49354b18c43a9f9b8f789d3ae822f34b408eaee8d3e70b"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "7b51eee3ac7ac860b2cc4f99c00508250bdbf14c4a72e6e7cc2cade99690c26f" => :el_capitan
    sha256 "e90d7190c6f06ba2107d4f3bf85ca798840642f00c6bb1f3872cc0a05efa3b83" => :yosemite
    sha256 "ae23a194badab407ea3489991314f295f2ec7c6942dd60f0e81925eb94333dec" => :mavericks
    sha256 "87d6cc4e3a3b868ee1a98f2e148060ed4a69d2cd593944ebed83fe887c7cd080" => :mountain_lion
  end

  depends_on :xcode => :build

  def install
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match /probe \[success\]/m, shell_output("#{bin}/chuck --probe 2>&1")
  end
end
