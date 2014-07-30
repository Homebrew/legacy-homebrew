require "formula"

class Libvisio < Formula
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "http://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.0.tar.xz"
  sha1 "c82e5c7ad25e513c268032cda9febd01b8879504"

  bottle do
    cellar :any
    revision 1
    sha1 "ff0a3bed223e14036633795b616dd56ae2cc6a80" => :mavericks
    sha1 "67cc8107265473f4165d364103f7c805d7f6f930" => :mountain_lion
    sha1 "f5c6b08278f5a3d8e3d89b16765ba7b3a0a9b65c" => :lion
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
                    "-lrevenge-stream-0.0", "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-lvisio-0.1", "-I#{Formula["libvisio"].include}/libvisio-0.1"
    system "./test"
  end
end
