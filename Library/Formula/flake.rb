class Flake < Formula
  desc "FLAC audio encoder"
  homepage "http://flake-enc.sourceforge.net"
  url "https://downloads.sourceforge.net/project/flake-enc/flake/0.11/flake-0.11.tar.bz2"
  sha256 "8dd249888005c2949cb4564f02b6badb34b2a0f408a7ec7ab01e11ceca1b7f19"

  def install
    ENV.j1
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
