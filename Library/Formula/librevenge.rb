require "formula"

class Librevenge < Formula
  homepage 'http://sourceforge.net/p/libwpd/wiki/librevenge/'
  url 'http://dev-www.libreoffice.org/src/librevenge-0.0.1.tar.bz2'
  sha1 '738d68bf54ec97fd48c41284aabbfd5a0d2db4ce'

  bottle do
    cellar :any
    sha1 "c8479e57f7f14753bf37f9c6ee254c2ca4283c46" => :mavericks
    sha1 "b91249c93c6d0c11c6a4f1247d8241206ad26ad4" => :mountain_lion
    sha1 "738338d4bc36e49299ab1a9148d7a1686ae45ed0" => :lion
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
    system ENV.cc, "test.cpp", "-lrevenge-0.0", "-I#{include}/librevenge-0.0"
  end
end
