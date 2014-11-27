require "formula"

class Libetonyek < Formula
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "http://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.1.tar.xz"
  sha1 "024fd730b062d1df54de0352323d03d011e59277"

  bottle do
    cellar :any
    revision 2
    sha1 "979c95b08b3675fbf4de2a545a7e5215d1b27fc4" => :yosemite
    sha1 "2b8c5ba7fb1a0f8b810e0e73184430258d14defb" => :mavericks
    sha1 "39814df03e02f6e583817ea57e5bf6352a7f655b" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libwpd"
  depends_on "librevenge"

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
      #include <libetonyek/EtonyekDocument.h>
      int main() {
        return libetonyek::EtonyekDocument::RESULT_OK;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-I#{include}/libetonyek-0.1",
                    "-L#{Formula["librevenge"].lib}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-letonyek-0.1"
    system "./test"
  end
end
