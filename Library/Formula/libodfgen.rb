class Libodfgen < Formula
  desc "ODF export library for projects using librevenge"
  homepage "https://sourceforge.net/p/libwpd/wiki/libodfgen/"
  url "http://dev-www.libreoffice.org/src/libodfgen-0.1.4.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/libwpd/libodfgen/libodfgen-0.1.4/libodfgen-0.1.4.tar.bz2"
  sha256 "f74999d2c93ac0cc077a0a9c36340daff29dc772992160ae81dd010345f72b80"

  bottle do
    cellar :any
    revision 1
    sha256 "9472f468c381ec54266f2a58fe062b240f2b9434ccd66b638a26e7d00d4b5f21" => :el_capitan
    sha256 "507de249c787af8d91177ae195356c8004483c23e3fc4e3829cbe002787d43b6" => :yosemite
    sha256 "fd1131394ab4c726564a69bf78b677dab5472f0e4563a089bddda5ff076e84fd" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "libetonyek" => :build
  depends_on "libwpd"
  depends_on "librevenge"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--with-sharedptr=boost",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libodfgen/OdfDocumentHandler.hxx>
      int main() {
        return ODF_FLAT_XML;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
      "-lrevenge-0.0",
      "-I#{Formula["librevenge"].include}/librevenge-0.0",
      "-L#{Formula["librevenge"].lib}",
      "-lodfgen-0.1",
      "-I#{include}/libodfgen-0.1",
      "-L#{lib}"
    system "./test"
  end
end
