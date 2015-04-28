class Libcdr < Formula
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "http://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.1.tar.bz2"
  sha256 "72fe7bbbf2275242acdf67ad2f9b6c71ac9146a56c409def360dabcac5695b49"

  bottle do
    cellar :any
    sha256 "2ca4c0020f72966b3070d910dec34601cf6b22be312a539f2d9ee73d0bfa4139" => :yosemite
    sha256 "f3ba5ff4b6bd4f4afe141d5b38bfb40355abb37d1865284b117c5bd766b7f613" => :mavericks
    sha256 "cf6b2ed3191cd32b9303f759226da36ba336a9d6448587fcc8bf8f7fd1a20037" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

  def install
    ENV.cxx11
    system "./configure", "--disable-werror",
                          "--without-docs",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libcdr/libcdr.h>
      int main() {
        libcdr::CDRDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                                "-I#{Formula["librevenge"].include}/librevenge-0.0",
                                "-I#{include}/libcdr-0.1",
                                "-lcdr-0.1"
    system "./test"
  end
end
