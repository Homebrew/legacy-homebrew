class Tcptunnel < Formula
  desc "TCP port forwarder"
  homepage "http://www.vakuumverpackt.de/tcptunnel/"
  url "https://github.com/vakuum/tcptunnel/archive/v0.8.tar.gz"
  sha256 "1926e2636d26570035a5a0292c8d7766c4a9af939881121660df0d0d4513ade4"

  def install
    bin.mkpath
    system "./configure", "--prefix=#{bin}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/tcptunnel", "--version"
  end
end
