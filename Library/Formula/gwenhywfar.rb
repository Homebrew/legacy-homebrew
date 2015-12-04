class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "http://www.aqbanking.de/"
  url "http://www2.aquamaniac.de/sites/download/download.php?package=01&release=01&file=01&dummy=gwenhywfar-4.14.0.tar.gz"
  sha256 "7e0ec2f1cab7d22a5ae0066e0ef827d4affec59470b1bdbc42132b58a903dd03"
  head "http://git.aqbanking.de/git/gwenhywfar.git"

  bottle do
    sha256 "46680498dc76f514f537dfd8881df82ad8bb41c48eca6c0133cf10aea3839506" => :el_capitan
    sha256 "04f45fcee06842a6e767b10e1a003a3f232486de5ac39104b4f98d9488a56078" => :yosemite
    sha256 "0969c806c101ab0fe17652bbb3727ef57f276216e8a645247185b15d30c76d87" => :mavericks
  end

  option "without-cocoa", "Build without cocoa support"
  option "with-check", "Run build-time check"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "openssl"
  depends_on "libgcrypt"
  depends_on "gtk+" => :optional
  depends_on "qt" => :optional

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

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gwenhywfar/gwenhywfar.h>

      int main()
      {
        GWEN_Init();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/gwenhywfar4", "-L#{lib}", "-lgwenhywfar", "-o", "test"
    system "./test"
  end
end
