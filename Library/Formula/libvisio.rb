class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "http://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.3.tar.xz"
  sha256 "943e03b1e6c969af4c2133a6671c9630adf3aaf8d460156744a28f58c9f47cd8"

  bottle do
    cellar :any
    sha256 "2b44b226a48b76cdd2cea1d17d88252fd2d254d552939aaf3d98cc182741741b" => :el_capitan
    sha256 "049915e816c2d8d2c3a80b138494e64c9f89616a8434c8caafbc88da6de094c3" => :yosemite
    sha256 "4e66fae8303d256b5ee16e8766ee9ee82146d17d57555434b8fdd04fde6dc607" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "cppunit" => :build
  depends_on "librevenge"
  depends_on "icu4c"


  def install
    # Needed for Boost 1.59.0 compatibility.
    ENV["LDFLAGS"] = "-lboost_system-mt"
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
