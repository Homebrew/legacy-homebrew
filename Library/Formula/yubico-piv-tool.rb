require "formula"

class YubicoPivTool < Formula
  homepage "http://opensource.yubico.com/yubico-piv-tool/"
  url "http://opensource.yubico.com/yubico-piv-tool/releases/yubico-piv-tool-0.1.0.tar.gz"
  sha1 "bebf01280e0ace0c43ab398a06cc0bc2e7fe2af9"

  bottle do
    cellar :any
    sha1 "97d204bea07ee9e00d6f3281a84f94e27b55e174" => :mavericks
    sha1 "621490567eed24c753f712668308a84880940bcd" => :mountain_lion
    sha1 "19547ccfa0e742e5258907c28e039d5ed8a7e707" => :lion
  end

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
