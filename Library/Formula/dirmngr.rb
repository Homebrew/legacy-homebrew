class Dirmngr < Formula
  desc "Server for managing certificate revocation lists"
  homepage "https://www.gnupg.org"
  url "ftp://ftp.gnupg.org/gcrypt/dirmngr/dirmngr-1.1.1.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dirmngr/dirmngr_1.1.1.orig.tar.bz2"
  sha256 "d2280b8c314db80cdaf101211a47826734443436f5c3545cc1b614c50eaae6ff"
  revision 1

  bottle do
    revision 2
    sha256 "a07f99c0a38b6bb454d2c596562717d651779a1f189ab15809e21c3047079e79" => :el_capitan
    sha256 "ca8d166e23d655deb6fba0f22b675482791bcfe1008ec07bdef8bfdc5f7240ec" => :yosemite
    sha256 "ce5b93c43cf4d15a6510782663583683a1fa0582f4f2a270230c91b081ae2ba8" => :mavericks
    sha256 "5b4f0faf48899220e39b649aed3d3a772393bfa02f066dcfb8b6d47cc832165d" => :mountain_lion
  end

  depends_on "libassuan"
  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "pth"

  patch :p0 do
    # patch by upstream developer to fix an API incompatibility with libgcrypt >=1.6.0
    # causing immediate segfault in dirmngr. see http://bugs.g10code.com/gnupg/issue1590
    url "http://bugs.g10code.com/gnupg/file419/dirmngr-pth-fix.patch"
    sha256 "0efbcf1e44177b3546fe318761c3386a11310a01c58a170ef60df366e5160beb"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make"
    system "make", "install"
  end

  test do
    system "dirmngr-client", "--help"
    system "dirmngr", "--help"
  end
end
