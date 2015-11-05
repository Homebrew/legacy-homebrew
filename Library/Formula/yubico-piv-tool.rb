class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey NEO PIV applet"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/releases/yubico-piv-tool-1.0.3.tar.gz"
  sha256 "4cec162dda45851741a3b58c492797cc051ef59192ca35a3bdd125fc2ebd6210"

  bottle do
    cellar :any
    sha256 "f9c94040549aaeaa4671d781129fe80f6d7e3a4ce73d994db17e7ff8d65c478c" => :el_capitan
    sha256 "dbfd184304634e4f427cb4ee6efbb7284c19d2156dcdfacc6b133718e960ff66" => :yosemite
    sha256 "18faf2c6ab89903b6a30e1d9d0b4251b355437edfdef8742dd83b46227e7429a" => :mavericks
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
    assert_match "yubico-piv-tool 1.0.3", shell_output("#{bin}/yubico-piv-tool --version")
  end
end
