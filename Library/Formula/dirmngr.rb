require 'formula'

class Dirmngr < Formula
  homepage 'http://www.gnupg.org'
  url 'ftp://ftp.gnupg.org/gcrypt/dirmngr/dirmngr-1.1.1.tar.bz2'
  mirror 'http://ftp.debian.org/debian/pool/main/d/dirmngr/dirmngr_1.1.1.orig.tar.bz2'
  sha1 'e708d4aa5ce852f4de3f4b58f4e4f221f5e5c690'
  revision 1

  bottle do
    sha1 "a0e3054879e746f6f8c3c9cd52ffc086df0baf63" => :mavericks
    sha1 "55a72926469641815471da58e2f727142865b175" => :mountain_lion
    sha1 "5aa4fbc1050bfebe9f7319183204dc0ac818a832" => :lion
  end

  depends_on 'libassuan'
  depends_on 'libgpg-error'
  depends_on 'libgcrypt'
  depends_on 'libksba'
  depends_on 'pth'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make"
    system "make install"
  end
end
