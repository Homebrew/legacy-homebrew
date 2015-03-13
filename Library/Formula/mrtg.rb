class Mrtg < Formula
  homepage "https://oss.oetiker.ch/mrtg/"
  url "https://oss.oetiker.ch/mrtg/pub/mrtg-2.17.4.tar.gz"
  sha256 "5efa7fae8040159208472e5f889be5b41d8c8a2ea6b31616f0f75cc7f48d2365"

  depends_on "gd"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cfgmaker", "--nointerfaces", "localhost"
  end
end
