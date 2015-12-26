class Libwpg < Formula
  desc "Library for reading and parsing Word Perfect Graphics format"
  homepage "http://libwpg.sourceforge.net/"
  url "http://dev-www.libreoffice.org/src/libwpg-0.3.1.tar.bz2"
  sha256 "29049b95895914e680390717a243b291448e76e0f82fb4d2479adee5330fbb59"

  bottle do
    cellar :any
    sha256 "976dc5670fc09408ea89d58519d713605aad953fcd47b836ce1d5204ccb790ac" => :el_capitan
    sha256 "ea801f9c413c99ec2ba1b6edee8e8bd574b7be60599c9586782b352f5d3bf498" => :yosemite
    sha256 "76c66ba7812eeea20b3e250646cdcb92c0684a12679397f831f92ae7b042159d" => :mavericks
    sha256 "eb5de2dd771901a8836ffc5531660d39c6d3612b6d8f82d9bc8a531e4e175b7d" => :mountain_lion
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
