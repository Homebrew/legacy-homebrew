require "formula"

class Libetonyek < Formula
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "http://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.1.tar.xz"
  sha1 "024fd730b062d1df54de0352323d03d011e59277"

  bottle do
    cellar :any
    revision 1
    sha1 "bc49ceed23c6bbb529231c2b235f3b4eab942d3b" => :mavericks
    sha1 "2e9fb0728d15de615a4f7c0749275f921c4601ba" => :mountain_lion
    sha1 "12e753556b226cce7a8f8bd80ae95f76037984a5" => :lion
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
