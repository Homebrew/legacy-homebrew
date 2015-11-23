class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey NEO PIV applet"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/releases/yubico-piv-tool-1.1.0.tar.gz"
  sha256 "457407e462d8d11c80788641516d65b92cc327b120b4e5bbf43f0d0679db1c39"

  bottle do
    cellar :any
    sha256 "2b1543c1fd96d93dd31556cdf65dbed72566d4a101e7b830ef7cd090d9630bf6" => :el_capitan
    sha256 "a51317cc84545d6488edf2e705979fc7c1e8f67523d8735be50fcc93bbd4ba07" => :yosemite
    sha256 "1eaf3988ee584e3a2ebd734207d6dc777fabd337bcc1167eb87ad891f99076b0" => :mavericks
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
    assert_match "yubico-piv-tool 1.1.0", shell_output("#{bin}/yubico-piv-tool --version")
  end
end
