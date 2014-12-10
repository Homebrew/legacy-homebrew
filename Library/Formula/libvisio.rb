require "formula"

class Libvisio < Formula
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "http://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.0.tar.xz"
  sha1 "c82e5c7ad25e513c268032cda9febd01b8879504"
  revision 3

  bottle do
    cellar :any
    revision 1
    sha1 "99ed3132f737611f552f499c593171b9c5de98f1" => :yosemite
    sha1 "fe4be3eedf1ecfc4e30c2ced7dba2a8c01483e95" => :mavericks
    sha1 "100c2d78d59c91ab3f6d77937cc35a669e24d383" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
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
