class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "http://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.1.tar.bz2"
  sha256 "72fe7bbbf2275242acdf67ad2f9b6c71ac9146a56c409def360dabcac5695b49"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "ae25bf920b37198c7968453ecdf8bab7749e1498f61d25b0de6987b1c9959330" => :el_capitan
    sha256 "4143fa583f4d466d3e7f07fd5c51f553e410dad2739a7fed6af52a82e23fdb69" => :yosemite
    sha256 "5a4366e25d4a084f3d2a5b87f21e93fe78bf026ca6785da30cdc12435a401456" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
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
