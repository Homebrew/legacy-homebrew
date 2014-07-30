require "formula"

class Libvisio < Formula
  homepage "http://www.freedesktop.org/wiki/Software/libvisio/"
  url "http://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.0.tar.bz2"
  sha1 "5029b4872c90c779e31d0ddf7dbb8f3eb68acd5e"
  revision 1

  bottle do
    cellar :any
    sha1 "5b7af3a34301558c02ba25bf09087d44479427e9" => :mavericks
    sha1 "19286ead4b765628712f516e4bb161c4b7caf2ff" => :mountain_lion
    sha1 "6bac7cd8dce1f27c0acfc41e74348333abcb1f43" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libwpd"
  depends_on "libwpg"
  depends_on "icu4c"
  depends_on "librevenge"

  def install
    inreplace "libvisio.pc.in", /^Requires\.private:.*$/, ""
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
                    "-lvisio-0.1", "-I#{include}/libvisio-0.1"
    system "./test"
  end
end
