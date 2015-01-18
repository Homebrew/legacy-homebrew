require "formula"

class YubicoPivTool < Formula
  homepage "http://opensource.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-0.1.2.tar.gz"
  sha1 "cea66a3f50c41676a7a5ff0ffab08e2f60826a12"

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
