class Dirmngr < Formula
  homepage "http://www.gnupg.org"
  url "ftp://ftp.gnupg.org/gcrypt/dirmngr/dirmngr-1.1.1.tar.bz2"
  mirror "http://ftp.debian.org/debian/pool/main/d/dirmngr/dirmngr_1.1.1.orig.tar.bz2"
  sha1 "e708d4aa5ce852f4de3f4b58f4e4f221f5e5c690"
  revision 1

  bottle do
    revision 1
    sha1 "55a34a49127b13bf4b118b404b5fe9c204dffb96" => :yosemite
    sha1 "d59388da85e392b7ab6b4057b2b7db270d29807f" => :mavericks
    sha1 "ae23c406d2c1b181ad987d08121cea3f20e04a6e" => :mountain_lion
  end

  depends_on "libassuan"
  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "pth"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make"
    system "make", "install"
  end

  test do
    system "dirmngr-client", "--help"
  end
end
