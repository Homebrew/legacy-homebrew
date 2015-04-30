class Libmspub < Formula
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "http://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.2.tar.xz"
  sha256 "b0baabf82d20c08ad000e80fa02154ce2f2ffde1ee60240d6e3a917c3b35560f"

  bottle do
    cellar :any
    sha256 "e8579e625cc52e114ae3aea971c4637c652d8c403b552b2ed6f929bcb50b6fae" => :yosemite
    sha256 "bbe85159e672845b147691ac293dce9aaf6e7a68f9bf8ca35df7132e866d2377" => :mavericks
    sha256 "05d1c4d9e867bb51f4334e731bc207d48c200595f110f1e40a1e35f3ddd05dcb" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "libwpd"
  depends_on "icu4c"
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
    #include <librevenge-stream/librevenge-stream.h>
    #include <libmspub/MSPUBDocument.h>
    int main() {
        librevenge::RVNGStringStream docStream(0, 0);
        libmspub::MSPUBDocument::isSupported(&docStream);
        return 0;
    }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-lmspub-0.1", "-I#{include}/libmspub-0.1",
                    "-L#{lib}", "-L#{Formula["librevenge"].lib}"
    system "./test"
  end
end
