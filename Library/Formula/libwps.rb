class Libwps < Formula
  desc "Library to import files in MS Works format"
  homepage "http://libwps.sourceforge.net"
  url "http://dev-www.libreoffice.org/src/libwps-0.3.0.tar.bz2"
  sha256 "243d1dfc9bb53ac9d05405379a119e9b7d999714de3a3d56f4d3c505cedad43a"

  bottle do
    cellar :any
    revision 1
    sha1 "6da56fae08558950c9134a762f6e7491fabbb7b8" => :yosemite
    sha1 "a1785cc9c07420d3e88a7000e7b42bb96091baea" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libwpd"
  depends_on "librevenge"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          # Installing Doxygen docs trips up make install
                          "--prefix=#{prefix}", "--without-docs"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libwps/libwps.h>
      int main() {
        return libwps::WPS_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                  "-lrevenge-0.0",
                  "-I#{Formula["librevenge"].include}/librevenge-0.0",
                  "-L#{Formula["librevenge"].lib}",
                  "-lwpd-0.10",
                  "-I#{Formula["libwpd"].include}/libwpd-0.10",
                  "-L#{Formula["libwpd"].lib}",
                  "-lwps-0.3", "-I#{include}/libwps-0.3", "-L#{lib}"
    system "./test"
  end
end
