require "formula"

class Libwpg < Formula
  homepage 'http://libwpg.sourceforge.net/'
  url 'http://dev-www.libreoffice.org/src/libwpg-0.3.0.tar.bz2'
  sha1 'c8422f9a01e98ff3cb5d64d518e61f6a0bb77551'

  depends_on 'pkg-config' => :build
  depends_on 'libwpd'
  depends_on 'librevenge'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/'test.cpp').write <<-EOS.undent
      #include <libwpg/libwpg.h>
      int main() {
        return libwpg::WPG_AUTODETECT;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-lrevenge-0.0", "-I#{Formula['librevenge'].include}/librevenge-0.0",
                   "-lwpg-0.3", "-I#{include}/libwpg-0.3"
  end
end
