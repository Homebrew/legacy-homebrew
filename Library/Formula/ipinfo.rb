require "formula"

class Ipinfo < Formula
  homepage "http://kyberdigi.cz/projects/ipinfo/"
  url "http://kyberdigi.cz/projects/ipinfo/files/ipinfo-1.1.tar.gz"
  sha1 "371800b2dfebb7de4ed0cca8d66c77d46477a596"

  bottle do
    cellar :any
    sha1 "9982cd38077f1d542736f5db32f76db350c2d987" => :mavericks
    sha1 "562457c3ac4bcdd8dc8ab856272d37b16e799b7d" => :mountain_lion
    sha1 "f7fe28e279d45b77d5e74b5710682e11a7814fe8" => :lion
  end

  def install
    system "make", "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "install"
  end

  test do
    system "ipinfo", "127.0.0.1"
  end
end
