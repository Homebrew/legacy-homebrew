require "formula"

class Libetonyek < Formula
  homepage "http://www.freedesktop.org/wiki/Software/libetonyek/"
  url "http://dev-www.libreoffice.org/src/libetonyek-0.1.1.tar.xz"
  sha1 "024fd730b062d1df54de0352323d03d011e59277"

  bottle do
    cellar :any
    sha1 "aed0a80bfcfc83748e4e03cf640fe176c0f211d5" => :mavericks
    sha1 "9ccf399948d3423af1134d541033988dfc3270a0" => :mountain_lion
    sha1 "a3a53a426861f26ee026676dd0232427bda8f376" => :lion
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
                    "-lrevenge-0.0", "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-letonyek-0.1", "-I#{Formula["libetonyek"].include}/libetonyek-0.1"
    system "./test"
  end
end
