require "formula"

class Ipinfo < Formula
  homepage "http://kyberdigi.cz/projects/ipinfo/"
  url "http://kyberdigi.cz/projects/ipinfo/files/ipinfo-1.1.tar.gz"
  sha1 "371800b2dfebb7de4ed0cca8d66c77d46477a596"

  def install
    system "make", "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "install"
  end

  test do
    system "ipinfo", "127.0.0.1"
  end
end
