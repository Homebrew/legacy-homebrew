class Vbindiff < Formula
  homepage "http://www.cjmweb.net/vbindiff/"
  url "http://www.cjmweb.net/vbindiff/vbindiff-3.0_beta4.tar.gz"
  version "3.0_beta4"
  sha256 "7d5d5a87fde953dc2089746f6f6ab811d60e127b01074c97611898fb1ef1983d"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/vbindiff", "-L"
  end
end
