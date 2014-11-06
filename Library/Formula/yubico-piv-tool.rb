require "formula"

class YubicoPivTool < Formula
  homepage "http://opensource.yubico.com/yubico-piv-tool/"
  url "http://opensource.yubico.com/yubico-piv-tool/releases/yubico-piv-tool-0.1.0.tar.gz"
  sha1 "bebf01280e0ace0c43ab398a06cc0bc2e7fe2af9"

  bottle do
    cellar :any
    revision 1
    sha1 "f6b43a9e9cc47e364d6ab485ef839512a1703a36" => :yosemite
    sha1 "f5075927f40449a679b481b35d6199f4dc19aa7b" => :mavericks
    sha1 "497a7c7c92514985126b41f6630a92dcbd09f23b" => :mountain_lion
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
