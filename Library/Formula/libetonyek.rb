class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "http://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.5.tar.xz"
  sha256 "29f8097f77a193511e940f7a70dfc6ac7fad57fbfc6e60b81fa1ee011daea903"

  bottle do
    cellar :any
    sha256 "62cccdece5d76f43ac0fd55eaccbd7a186848b962967140e322dbcba54909ce0" => :el_capitan
    sha256 "f2d6be638e76f14060ff49ae65a5082e9538353e4688e04688129337b64815ae" => :yosemite
    sha256 "73a38f30705c97a32aade008ac09e26ed51c74bb6146794d07cae0af607e427d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "librevenge"
  depends_on "glm"
  depends_on "mdds"

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
