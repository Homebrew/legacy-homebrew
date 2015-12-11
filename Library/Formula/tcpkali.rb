class Tcpkali < Formula
  desc "High performance TCP and WebSocket load generator and sink"
  homepage "https://github.com/machinezone/tcpkali"
  url "https://github.com/machinezone/tcpkali/releases/download/v0.7/tcpkali-0.7.tar.gz"
  sha256 "c917e2384b171d4c8906192266376cab6b1f9191810a4f209d7371639e3f2185"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tcpkali", "--version"
    system "#{bin}/tcpkali", "-l1237", "-T0.5", "127.1:1237"
  end
end
