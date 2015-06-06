class Librevenge < Formula
  desc "Base library for writing document import filters"
  homepage "http://sourceforge.net/p/libwpd/wiki/librevenge/"
  url "http://dev-www.libreoffice.org/src/librevenge-0.0.2.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/libwpd/librevenge/librevenge-0.0.2/librevenge-0.0.2.tar.bz2"
  sha1 "a59cf2372b8deac044a407d05730befcd010e997"

  bottle do
    cellar :any
    sha1 "fc55b9d9f55ba18639c0ab7d58a28b459aa907c2" => :yosemite
    sha1 "063b7acffa5c58bd4706e6f128352a8646b5d396" => :mavericks
    sha1 "fb4060640938625a3a83c6a42dc479d5318140fd" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build

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
