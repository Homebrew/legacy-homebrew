class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "http://www.aqbanking.de/"
  url "http://www2.aquamaniac.de/sites/download/download.php?package=01&release=01&file=01&dummy=gwenhywfar-4.14.0.tar.gz"
  sha256 "7e0ec2f1cab7d22a5ae0066e0ef827d4affec59470b1bdbc42132b58a903dd03"
  revision 1

  head "http://git.aqbanking.de/git/gwenhywfar.git"

  bottle do
    sha256 "a862274810765ea8012c59b3277b4f2ac82981aa8817070f885872c7074784f4" => :el_capitan
    sha256 "fc2fe0818ae3bb051544dd9587473529d2c4f17af60052ce349076650263b916" => :yosemite
    sha256 "6066462c7dc97f8ccb8f4f89f5cc149faf11404a7f6c57a5a24c28d0034d5e3f" => :mavericks
  end

  option "without-cocoa", "Build without cocoa support"
  option "with-test", "Run build-time check"

  deprecated_option "with-check" => "with-test"

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

    # https://devel.aqbanking.de/trac/aqbanking/ticket/247
    # http://www.gnutls.org/manual/html_node/Priority-Strings.html
    inreplace "src/sio/syncio_tls.c", "gnutls_protocol_set_priority", "gnutls_priority_set"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-guis=#{guis.join(" ")}"
    system "make", "check" if build.with? "test"
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
