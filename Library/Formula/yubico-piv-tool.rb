require "formula"

class YubicoPivTool < Formula
  homepage "http://opensource.yubico.com/yubico-piv-tool/"
  url "http://opensource.yubico.com/yubico-piv-tool/releases/yubico-piv-tool-0.1.0.tar.gz"
  sha1 "bebf01280e0ace0c43ab398a06cc0bc2e7fe2af9"

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/yubico-piv-tool", "--version"
  end
end
