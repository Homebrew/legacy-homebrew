class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "http://www.aqbanking.de/"
  url "http://www.aquamaniac.de/sites/download/download.php?package=01&release=78&file=01&dummy=gwenhywfar-4.13.1.tar.gz"
  sha256 "4beca892c1235548ea0ae30132a6d2e57911c22340746585395ccb01d84ec72b"
  head "http://git.aqbanking.de/git/gwenhywfar.git"

  bottle do
    sha256 "83b13c2c8b968c7c19b6cf841dc70bdd23a6cdd1d79aa444ec7ba047358f2ef9" => :yosemite
    sha256 "53f9edbc41cf1692bd969acac3d1239d7f878bac81efce7fc6889a2a73406afb" => :mavericks
    sha256 "e81cb75004757c9bb4823c8fa5c126f291eabe10bd238af62de5660c50cdcc3a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "openssl"
  depends_on "libgcrypt"
  depends_on "gtk+" => :optional
  depends_on "qt" => :optional

  option "without-cocoa", "Build without cocoa support"
  option "with-check", "Run build-time check"

  def install
    guis = []
    guis << "gtk2" if build.with? "gtk+"
    guis << "qt4" if build.with? "qt"
    guis << "cocoa" if build.with? "cocoa"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-guis=#{guis.join(" ")}"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
