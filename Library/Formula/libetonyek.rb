class Libetonyek < Formula
  desc "Interpret and import Apple Keynote presentations"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libetonyek"
  url "http://dev-www.libreoffice.org/src/libetonyek/libetonyek-0.1.3.tar.xz"
  sha256 "fe12276a62bd5f5ca4f5bfbd4938a74d097084e1f9fe173e521f63203f56f055"

  bottle do
    cellar :any
    sha256 "626991163cce2d71306b8cc2182f0881006d23402b6bd6d970c610d386b02c4a" => :yosemite
    sha256 "6f3d2a303b340f3e1a89f4d0d07a25609a8888c3cbabecb90abdc7b18a622687" => :mavericks
    sha256 "a3df704492a824517d62d3ca29f0b916b8a52486a9745f300090d2c9dec2f038" => :mountain_lion
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "glm"
  depends_on "librevenge"
  depends_on "libxml2"

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
