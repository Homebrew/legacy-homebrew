class Tlcr < Formula
  desc "Simple terminal-based client for TLDR pages, written in Crystal"
  homepage "https://github.com/porras/tlcr"
  url "https://github.com/porras/tlcr/archive/0.3.0.tar.gz"
  sha256 "d0f8be0b5d85fe0ed9587da4d32bdf7c8c401014bca83200aa8833f64d40b0c9"
  head "https://github.com/porras/tlcr.git"

  depends_on "crystal-lang" => :build
  depends_on "openssl"
  depends_on "libevent"
  depends_on "libpcl"
  depends_on "bdw-gc"

  def install
    system "shards"
    system "crystal", "build", "--release", "tlcr.cr"
    bin.install "tlcr"
    doc.install "LICENSE"
  end

  test do
    system "tlcr", "--version"
  end
end
