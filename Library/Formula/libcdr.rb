require "formula"

class Libcdr < Formula
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "http://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.0.tar.bz2"
  sha1 "fea63690acea2b9eac5dc6f51232154b7bb41a9e"

  #bottle do
  #  cellar :any
  #  sha1 "" => :mavericks
  #  sha1 "" => :mountain_lion
  #  sha1 "" => :lion
  #end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"
  depends_on 'homebrew/dupes/zlib'

  needs :cxx11

  def install
    ENV.libcxx
    ENV.cxx11
    system "./configure", # "--disable-werror",
                          "--without-docs"
    system "make", "install"
  end

  # test do
  #  (testpath/"test.cpp").write <<-EOS.undent
  #  #include <librevenge-stream/librevenge-stream.h>
  #  #include <libmspub/MSPUBDocument.h>
  #  int main() {
  #      librevenge::RVNGStringStream docStream(0, 0);
  #      libmspub::MSPUBDocument::isSupported(&docStream);
  #      return 0;
  #  }
  #  EOS
  #  system ENV.cxx, "test.cpp", "-o", "test", "-lrevenge-stream-0.0",
  #                  "-I#{Formula["librevenge"].include}/librevenge-0.0",
  #                  "-lmspub-0.1", "-I#{include}/libmspub-0.1"
  #  system "./test"
  #end
end
