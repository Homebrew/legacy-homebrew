require "formula"

class Libmspub < Formula
  homepage "http://www.freedesktop.org/wiki/Software/libmspub/"
  url "http://dev-www.libreoffice.org/src/libmspub-0.1.0.tar.bz2"
  sha1 "4dc9b9c85cb1c30dde071a88edf40a629b6de666"

  bottle do
    cellar :any
    sha1 "a851788338a9fe73b27d69f363e5c5961c077d27" => :mavericks
    sha1 "7593f6502162d3012b41580554feea65e429c8d2" => :mountain_lion
    sha1 "3eda7f552d5fa7e097a9ee306ec5b5b8731102a4" => :lion
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
                    "-lmspub-0.1", "-I#{include}/libmspub-0.1"
    system "./test"
  end
end
