require "formula"

class YubicoPivTool < Formula
  homepage "http://opensource.yubico.com/yubico-piv-tool/"
  url "http://opensource.yubico.com/yubico-piv-tool/releases/yubico-piv-tool-0.1.3.tar.gz"
  sha1 "425269827da9f47a6277bd42b6415c8527d9ff8e"

  bottle do
    cellar :any
    sha1 "4fc3bc4b53afbec9773d468435e23013c1718c55" => :yosemite
    sha1 "5c1509845c4d1d1726098e15cb5692e187c99aa2" => :mavericks
    sha1 "c9de161633dfcf2337390aec11826950d4dca00e" => :mountain_lion
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
