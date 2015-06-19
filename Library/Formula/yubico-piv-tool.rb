class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey NEO PIV applet"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/releases/yubico-piv-tool-0.1.6.tar.gz"
  sha256 "eff765169153fdf75ba4ff48eb2e4748f62623760bb5c15e4cce89b7263f59bb"

  bottle do
    cellar :any
    sha256 "8ce8bf57c35522df2368f4700060f872a9af329f8c49aaee59f159c937869cca" => :yosemite
    sha256 "7be9804e613191d9f50fa489313dbacfcc6c41e5e2d7417cb7f031a137709909" => :mavericks
    sha256 "f772eff93aff2c34503d4f50fbbe3679877f594acb32351a4054f3d203e591aa" => :mountain_lion
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
