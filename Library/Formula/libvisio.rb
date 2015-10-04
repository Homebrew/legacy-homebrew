class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "http://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.1.tar.xz"
  sha256 "4b510168d1465516fdf6e57c01e2f9eae1fc0ae232c74e44e70693bbc49227f1"
  revision 1

  bottle do
    cellar :any
    sha256 "2baf447a0865b93ddcf93afb2fbbe0ab2c0f0e37f0d5ebe6d2f7d4b618e428f2" => :yosemite
    sha256 "b2432c53569d0c8e0eb0befcb3b2f10ebdebcf8ca09c6f06299486652429a075" => :mavericks
    sha256 "2257bf59998222573140be09039f3a49ebf0a6c5badf3c896e1928b75baa25dd" => :mountain_lion
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
