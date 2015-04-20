class Libvisio < Formula
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "http://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.1.tar.xz"
  sha1 "2284866af215a56683bfe4d49a921a053eff4cf9"

  bottle do
    cellar :any
    sha1 "df77602d026ee51bea001bcb7744b6d2e83579f1" => :yosemite
    sha1 "ec7c204c7976255ee6e0b54a2e1e4957e2ed526f" => :mavericks
    sha1 "f616d10990778b77edd54db39653332ac9e60195" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "cppunit" => :build
  depends_on "libwpd"
  depends_on "libwpg"
  depends_on "icu4c"
  depends_on "librevenge"

  def install
    system "./configure", "--without-docs",
                          "-disable-dependency-tracking",
                          "--enable-static=no",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <librevenge-stream/librevenge-stream.h>
      #include <libvisio/VisioDocument.h>
      int main() {
        librevenge::RVNGStringStream docStream(0, 0);
        libvisio::VisioDocument::isSupported(&docStream);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-L#{Formula["librevenge"].lib}",
                    "-lvisio-0.1", "-I#{include}/libvisio-0.1", "-L#{lib}"
    system "./test"
  end
end
