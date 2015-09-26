class Ipinfo < Formula
  desc "Tool for calculation of IP networks"
  homepage "http://kyberdigi.cz/projects/ipinfo/"
  url "http://kyberdigi.cz/projects/ipinfo/files/ipinfo-1.1.tar.gz"
  sha256 "9ac70f4fa6e124834819c52ffc0f7b3332ff0ce3948865d084e687a6f58eb010"

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
