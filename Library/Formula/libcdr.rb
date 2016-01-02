class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "http://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.2.tar.bz2"
  sha256 "d05a986dab9f960e64466072653a900d03f8257b084440d9d16599e16060581e"

  bottle do
    cellar :any
    sha256 "1f97806a9d54fab254bf8ec301530bb57fdbfeb69034be194a9667d0fd091ffc" => :el_capitan
    sha256 "fd5580294d2602a2d7feae8547cbd6f17d28e53c7570f874fe4a2c74d7083a35" => :yosemite
    sha256 "26a10451353a9e1f2d4c11e18d32c67004e7c7699f6881a0d3bc623bd5c81ecc" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "cppunit" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

  def install
    ENV.cxx11
    # Needed for Boost 1.59.0 compatibility.
    ENV["LDFLAGS"] = "-lboost_system-mt"
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
