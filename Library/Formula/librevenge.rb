class Librevenge < Formula
  desc "Base library for writing document import filters"
  homepage "https://sourceforge.net/p/libwpd/wiki/librevenge/"
  url "http://dev-www.libreoffice.org/src/librevenge-0.0.3.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/libwpd/librevenge/librevenge-0.0.3/librevenge-0.0.3.tar.bz2"
  sha256 "8cac287a4f3f37833a7b98304e2d3631d01cf577cb99b9311d5d5cd70680df55"

  bottle do
    cellar :any
    sha256 "3918ba5cde28067e9afd41881efd7948b79355751179cd01d4b34efa319bfbd1" => :el_capitan
    sha256 "b4b7a9049414395115d58fc95c48dfb2eb79fd0255e8ca85e1b076db891eeccb" => :yosemite
    sha256 "3b5bced358dc205d7a848854a9460bb5a49abaec97ada3d284ef2ad9262aa882" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost"


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
      #include <librevenge/librevenge.h>
      int main() {
        librevenge::RVNGString str;
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-lrevenge-0.0",
                   "-I#{include}/librevenge-0.0", "-L#{lib}"
  end
end
