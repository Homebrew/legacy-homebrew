require "formula"

class Libwpd < Formula
  homepage "http://libwpd.sourceforge.net/"
  url "http://dev-www.libreoffice.org/src/libwpd-0.10.0.tar.bz2"
  sha1 "bbcc6e528a69492fb2b4bbb9a56d385a29efc4c4"

  bottle do
    cellar :any
    sha1 "246a697a20f14159c48ae0fe7f43ca3e0d5dfa8b" => :mavericks
    sha1 "3816530feb78b6c426229dc6a1ab4df632338b11" => :mountain_lion
    sha1 "a546503b0ae01f120b4832ce6da08327d98dc3f5" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "librevenge"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libwpd/libwpd.h>
      int main() {
        return libwpd::WPD_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                   "-lrevenge-0.0", "-I#{Formula["librevenge"].include}/librevenge-0.0",
                   "-lwpd-0.10", "-I#{include}/libwpd-0.10"
    system "./test"
  end
end
