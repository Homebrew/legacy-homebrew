class Libwpg < Formula
  desc "Library for reading and parsing Word Perfect Graphics format"
  homepage "http://libwpg.sourceforge.net/"
  url "http://dev-www.libreoffice.org/src/libwpg-0.3.1.tar.bz2"
  sha256 "29049b95895914e680390717a243b291448e76e0f82fb4d2479adee5330fbb59"

  bottle do
    cellar :any
    sha256 "35c9a15742933b472934acaf8c97d1e551485da7325c9cbca5e06e61bb8a3ced" => :el_capitan
    sha256 "411ca160d35675435a00916c0b489ca4901dbc363ab8d7ad1c77fabfd80a8b10" => :yosemite
    sha256 "9ac0c4445fe2d1b7645ade070b070740b9ec3b5a0e1cf6908791b3b4649df9d6" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libwpd"
  depends_on "librevenge"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libwpg/libwpg.h>
      int main() {
        return libwpg::WPG_AUTODETECT;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                   "-lrevenge-0.0", "-I#{Formula["librevenge"].include}/librevenge-0.0",
                   "-lwpg-0.3", "-I#{include}/libwpg-0.3"
    system "./test"
  end
end
