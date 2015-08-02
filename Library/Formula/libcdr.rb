class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "http://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.1.tar.bz2"
  sha256 "72fe7bbbf2275242acdf67ad2f9b6c71ac9146a56c409def360dabcac5695b49"
  revision 1

  bottle do
    cellar :any
    sha256 "b452336a6390e8cbfd7e87804b0420a2e9240d170e82f186c9aa826df3a301e0" => :yosemite
    sha256 "6a86890eaf44898483b2e2bbd4e3b1fdafb8cc50ae690065593131453d6d4800" => :mavericks
    sha256 "7152daedf07953bdd29fae52358e5259ac88e565931eb9e70edf5c924de65043" => :mountain_lion
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
