class Bvi < Formula
  desc "Vi-like binary file (hex) editor"
  homepage "http://bvi.sourceforge.net"
  url "https://downloads.sourceforge.net/bvi/bvi-1.4.0.src.tar.gz"
  sha256 "015a3c2832c7c097d98a5527deef882119546287ba8f2a70c736227d764ef802"

  bottle do
    sha256 "4b5a3bdfa1bf083bde13338fc8fc5a8027880b3e79611ad064e44fd2f4d7a4a0" => :yosemite
    sha256 "7ec90f6665011faa3f1715cf6cc855270a536993633d8a4600cdb0492db16686" => :mavericks
    sha256 "75d2461715e5afacd35efcb188d580191db6ebe02607bc66ea52a813be21e29c" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    system "#{bin}/bvi", "-c", "q"
  end
end
