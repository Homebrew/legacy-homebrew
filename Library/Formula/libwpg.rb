require "formula"

class Libwpg < Formula
  homepage 'http://libwpg.sourceforge.net/'
  url 'http://dev-www.libreoffice.org/src/libwpg-0.3.0.tar.bz2'
  sha1 'c8422f9a01e98ff3cb5d64d518e61f6a0bb77551'

  bottle do
    cellar :any
    sha1 "50eed06b50a8793c2ef17e739e07bd2d20123236" => :mavericks
    sha1 "0ec7bbafdeeeb475d0f8b91801df6b14ba5eaf15" => :mountain_lion
    sha1 "8664b231a414048acf8e1e113178e689338325a7" => :lion
  end

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
    system ENV.cc, "test.cpp", "-o", "test",
                   "-lrevenge-0.0", "-I#{Formula['librevenge'].include}/librevenge-0.0",
                   "-lwpg-0.3", "-I#{include}/libwpg-0.3"
    system "./test"
  end
end
