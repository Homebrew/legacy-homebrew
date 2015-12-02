class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "http://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.1.tar.bz2"
  sha256 "72fe7bbbf2275242acdf67ad2f9b6c71ac9146a56c409def360dabcac5695b49"
  revision 2

  bottle do
    cellar :any
    sha256 "673cbd599ba4a4ba9cbdffd13e688932285591b84806b10643370d2feb11beb0" => :el_capitan
    sha256 "62a91376392eff0a32ad875dd7c52868e0225b9214939f1d253d4a0ca415a254" => :yosemite
    sha256 "69f35e9c988a305a26a04d7c4b8180bc769f05d9839e44fd43fe2ecfd737213f" => :mavericks
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
