require "formula"

class Libcdr < Formula
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "http://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.0.tar.bz2"
  sha1 "fea63690acea2b9eac5dc6f51232154b7bb41a9e"


  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

  needs :cxx11

  def install
    ENV.libcxx
    ENV.cxx11
    system "./configure", "--disable-werror",
                          "--without-docs"
    system "make", "install"
  end

    test do
    (testpath/'test.cpp').write <<-EOS.undent
      #include <libcdr/libcdr.h>
      int main() {
        libcdr::CDRDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{Formula["librevenge"].include}/librevenge-0.0", "-I#{HOMEBREW_PREFIX}/include/libcdr-0.1", "-lcdr-0.1"
  end
end
