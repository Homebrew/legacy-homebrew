class Fetchmail < Formula
  desc "fetch mail from a POP, IMAP, ETRN, or ODMR-capable server"
  homepage "http://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.3/fetchmail-6.3.26.tar.xz"
  sha256 "79b4c54cdbaf02c1a9a691d9948fcb1a77a1591a813e904283a8b614b757e850"

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--with-ssl"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end
