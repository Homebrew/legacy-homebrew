class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey NEO PIV applet"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/releases/yubico-piv-tool-1.0.0.tar.gz"
  sha256 "303f576eb17af65234f8a3feddcab6add13c6c2dc82de875e165b6bfc2b9bab7"

  bottle do
    cellar :any
    sha256 "f3b221c201b4529c8f776639202de62b15d6c9b98031381b2628f30b949f2244" => :yosemite
    sha256 "549b2b17f0ad0d9dcebe14b6f9eb70c6b51ecd165a34f5555a7ea78e1aa1f616" => :mavericks
    sha256 "126e099006c6bf097bf67a68532d12ee90fcc921f0f824cab557c5a73508e147" => :mountain_lion
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
