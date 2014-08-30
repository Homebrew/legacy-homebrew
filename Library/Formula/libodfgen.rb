require "formula"

class Libodfgen < Formula
  homepage "http://sourceforge.net/p/libwpd/wiki/libodfgen/"
  url "http://dev-www.libreoffice.org/src/libodfgen-0.1.1.tar.bz2"
  sha1 "13dc7a9fa69b8eb9af903596bbefaf044a3e76cc"

  bottle do
    cellar :any
    sha1 "8f8076250cc85c97dd42551cb7047961da2a40e3" => :mavericks
    sha1 "32cc5c62aef1c8d9e94206c0b43d800d49e0a223" => :mountain_lion
    sha1 "72b559f91f4df11b2f4a070165c7f9e285114d9a" => :lion
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
      "-lrevenge-0.0", "-I#{Formula["librevenge"].include}/librevenge-0.0",
      "-lodfgen-0.1", "-I#{Formula["libodfgen"].include}/libodfgen-0.1"
    system "./test"
  end
end
