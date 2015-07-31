class Asciitex < Formula
  desc "Generate ASCII-art representations of mathematical equations"
  homepage "http://asciitex.sourceforge.net"
  url "https://downloads.sourceforge.net/project/asciitex/asciiTeX-0.21.tar.gz"
  sha256 "abf964818833d8b256815eb107fb0de391d808fe131040fb13005988ff92a48d"

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
