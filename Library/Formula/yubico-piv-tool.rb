class YubicoPivTool < Formula
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/releases/yubico-piv-tool-0.1.6.tar.gz"
  sha256 "eff765169153fdf75ba4ff48eb2e4748f62623760bb5c15e4cce89b7263f59bb"

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
