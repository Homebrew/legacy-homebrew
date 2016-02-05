class Tcpkali < Formula
  desc "High performance TCP and WebSocket load generator and sink"
  homepage "https://github.com/machinezone/tcpkali"
  url "https://github.com/machinezone/tcpkali/releases/download/v0.7/tcpkali-0.7.tar.gz"
  sha256 "c917e2384b171d4c8906192266376cab6b1f9191810a4f209d7371639e3f2185"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbdeb97c8a187d5cf926ab94e086ad4f22fa7243d38e44da98b7bc620ed83e8c" => :el_capitan
    sha256 "138c06054147690136a8f5693448046f297add6ae52716a574f216bfde948df1" => :yosemite
    sha256 "04534dd1c88044f21c0cf60e028b66f261f7964584c70924242e98f8f5afa596" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tcpkali", "-l1237", "-T0.5", "127.1:1237"
  end
end
