require "formula"

class Libodfgen < Formula
  homepage "http://sourceforge.net/p/libwpd/wiki/libodfgen/"
  url "http://dev-www.libreoffice.org/src/libodfgen-0.1.1.tar.bz2"
  sha1 "13dc7a9fa69b8eb9af903596bbefaf044a3e76cc"

  bottle do
    cellar :any
    revision 1
    sha1 "3e617050b73e335a580a3f1784de41bc523a02c7" => :yosemite
    sha1 "8943717ca18bcd75acba6d970fe80bd5c61b43d3" => :mavericks
    sha1 "3876f9ec7649aab43452d45b7128aad94308cb28" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "libetonyek" => :build
  depends_on "libwpd"
  depends_on "librevenge"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--with-sharedptr=boost",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libodfgen/OdfDocumentHandler.hxx>
      int main() {
        return ODF_FLAT_XML;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
      "-lrevenge-0.0",
      "-I#{Formula["librevenge"].include}/librevenge-0.0",
      "-L#{Formula["librevenge"].lib}",
      "-lodfgen-0.1",
      "-I#{include}/libodfgen-0.1",
      "-L#{lib}"
    system "./test"
  end
end
