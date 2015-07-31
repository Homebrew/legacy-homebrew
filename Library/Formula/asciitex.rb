class Asciitex < Formula
  desc "Generate ASCII-art representations of mathematical equations"
  homepage "http://asciitex.sourceforge.net"
  url "https://downloads.sourceforge.net/project/asciitex/asciiTeX-0.21.tar.gz"
  sha256 "abf964818833d8b256815eb107fb0de391d808fe131040fb13005988ff92a48d"

  bottle do
    cellar :any
    sha256 "e9eadc960e449db67f305c3e1cc8d4f025288967bb8b6a37f5ba4bf5ad58493d" => :yosemite
    sha256 "31518a63d9b06f8e47ff57c5d6d22ca838abc2c1366d59db2bb8967971134d52" => :mavericks
    sha256 "cfcef4a17d2194a111da39891f06694d2056082915858d3cf938d3659b2d1a64" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-gtk"
    inreplace "Makefile", "man/asciiTeX_gui.1", ""
    system "make", "install"
    pkgshare.install "EXAMPLES"
  end

  test do
    system "#{bin}/asciiTeX", "-f", "#{pkgshare}/EXAMPLES"
  end
end
