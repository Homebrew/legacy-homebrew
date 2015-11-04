class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "http://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.3.tar.xz"
  sha256 "943e03b1e6c969af4c2133a6671c9630adf3aaf8d460156744a28f58c9f47cd8"

  bottle do
    cellar :any
    sha256 "6cd8e60063bb63145546a09014190066c5f8b1e62e0131578b126bcd77763b5e" => :el_capitan
    sha256 "db7f98d6a94e3c03912727036589c6eab7e992c4c48cc598d67894e1c202b47e" => :yosemite
    sha256 "0884c6df13acd44449610f63deb144abf452251f235e9506f5441c82544f84f5" => :mavericks
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
