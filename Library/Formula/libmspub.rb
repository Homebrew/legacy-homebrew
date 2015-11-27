class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "http://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.2.tar.xz"
  sha256 "b0baabf82d20c08ad000e80fa02154ce2f2ffde1ee60240d6e3a917c3b35560f"
  revision 1

  bottle do
    cellar :any
    sha256 "1071c3b83b68a2e5a67f70151e5f53139b679ffe9d6614de5f25dc297f6720e3" => :el_capitan
    sha256 "288aa9b5089d530db3ad439e547257d74f9bdaf6c504d11bd732781c0eeb599e" => :yosemite
    sha256 "610e745c2616ee42fd767ffc02d5df19f02ab05212bf520007e0b821f14869d4" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "libwpd"
  depends_on "icu4c"
  depends_on "librevenge"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
    #include <librevenge-stream/librevenge-stream.h>
    #include <libmspub/MSPUBDocument.h>
    int main() {
        librevenge::RVNGStringStream docStream(0, 0);
        libmspub::MSPUBDocument::isSupported(&docStream);
        return 0;
    }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-lmspub-0.1", "-I#{include}/libmspub-0.1",
                    "-L#{lib}", "-L#{Formula["librevenge"].lib}"
    system "./test"
  end
end
