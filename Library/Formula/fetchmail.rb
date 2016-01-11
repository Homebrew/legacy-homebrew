class Fetchmail < Formula
  desc "fetch mail from a POP, IMAP, ETRN, or ODMR-capable server"
  homepage "http://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.3/fetchmail-6.3.26.tar.xz"
  sha256 "79b4c54cdbaf02c1a9a691d9948fcb1a77a1591a813e904283a8b614b757e850"

  bottle do
    sha256 "13a9cb7b808e291f19f74416fa6338af53c22f4716418431dc912be596c97423" => :yosemite
    sha256 "c4ef27662612bf6061fc4d522e9f6adb239c64c78de20123cd62637cc1a2a63e" => :mavericks
    sha256 "4d7184ba429454fc400e82392d119a656b1a6310b23bb2d278e69d8580ddb5e9" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end
