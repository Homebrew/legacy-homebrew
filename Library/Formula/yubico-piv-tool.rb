require "formula"

class YubicoPivTool < Formula
  homepage "http://opensource.yubico.com/yubico-piv-tool/"
  url "http://opensource.yubico.com/yubico-piv-tool/releases/yubico-piv-tool-0.0.3.tar.gz"
  sha1 "594dad9ea190ac9c4c5c156f1a706613cc72e536"

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/yubico-piv-tool", "--action=version"
  end
end
