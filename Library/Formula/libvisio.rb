require "formula"

class Libvisio < Formula
  homepage "http://www.freedesktop.org/wiki/Software/libvisio/"
  url "http://dev-www.libreoffice.org/src/libvisio-0.1.0.tar.xz"
  sha1 "c82e5c7ad25e513c268032cda9febd01b8879504"

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
                    "-lrevenge-stream-0.0", "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-lvisio-0.1", "-I#{Formula["libvisio"].include}/libvisio-0.1"
    system "./test"
  end
end
