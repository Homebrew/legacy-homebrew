class Netcat < Formula
  desc "Utility for managing network connections"
  homepage "http://netcat.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/netcat/netcat/0.7.1/netcat-0.7.1.tar.bz2"
  sha256 "b55af0bbdf5acc02d1eb6ab18da2acd77a400bafd074489003f3df09676332bb"

  bottle do
    cellar :any
    sha256 "7ae495a909a2a25f6d8314857009a475034994234186682cc8dace4ea3c40b0c" => :yosemite
    sha256 "fcdf724d792f286ff086a53f214b26eb2ebf61d6430e0f9305bf274b5faf85a5" => :mavericks
    sha256 "d30aa6a393e3b6b28542e1d2a79252cda875e9a0dc817ad6b4920385669a2aaa" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end

  test do
    assert_match "HTTP/1.0", pipe_output("#{bin}/nc www.google.com 80", "GET / HTTP/1.0\r\n\r\n")
  end
end
