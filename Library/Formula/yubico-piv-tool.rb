require "formula"

class YubicoPivTool < Formula
  homepage "http://opensource.yubico.com/yubico-piv-tool/"
  url "http://opensource.yubico.com/yubico-piv-tool/releases/yubico-piv-tool-0.1.3.tar.gz"
  sha1 "425269827da9f47a6277bd42b6415c8527d9ff8e"

  bottle do
    cellar :any
    revision 1
    sha1 "3914bcd7c15e0bab43f98c9dbbbedb6838736331" => :yosemite
    sha1 "dfdd715a6959c56a71df5f757571ea29f3cd3163" => :mavericks
    sha1 "0c181fba1449f5330f98cf580e681de4055fe002" => :mountain_lion
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
