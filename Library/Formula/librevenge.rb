class Librevenge < Formula
  desc "Base library for writing document import filters"
  homepage "https://sourceforge.net/p/libwpd/wiki/librevenge/"
  url "http://dev-www.libreoffice.org/src/librevenge-0.0.4.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/libwpd/librevenge/librevenge-0.0.4/librevenge-0.0.4.tar.bz2"
  sha256 "c51601cd08320b75702812c64aae0653409164da7825fd0f451ac2c5dbe77cbf"

  bottle do
    cellar :any
    sha256 "3e16d90cf5e0bacbc83e410a154455e241b50a12fbc844565ca6c565bf569db8" => :el_capitan
    sha256 "1f021b70ff8591078386937b29dd419c53660b6ea3628a9c8f916ae37498d5c6" => :yosemite
    sha256 "cf4c15ade5beab757a4d6b3ba7ce4a3eac9e67c7835a2b53639dc6222fc3769f" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost"


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
      #include <librevenge/librevenge.h>
      int main() {
        librevenge::RVNGString str;
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-lrevenge-0.0",
                   "-I#{include}/librevenge-0.0", "-L#{lib}"
  end
end
