require "formula"

class Librevenge < Formula
  homepage 'http://sourceforge.net/p/libwpd/wiki/librevenge/'
  url 'http://dev-www.libreoffice.org/src/librevenge-0.0.1.tar.bz2'
  sha1 '738d68bf54ec97fd48c41284aabbfd5a0d2db4ce'

  bottle do
    cellar :any
    revision 1
    sha1 "b4530cc65a0d8844e94a5793eaa1e92ea8208338" => :yosemite
    sha1 "ddf0a4bd3c679bd60fdd847c2d029bdecf8be9fe" => :mavericks
    sha1 "205b4e1cbecbcb686fab50fafc1140438099756c" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'boost' => :build

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
    (testpath/'test.cpp').write <<-EOS.undent
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
