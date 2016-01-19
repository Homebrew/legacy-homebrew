class Libfreehand < Formula
  desc "Interpret and import Aldus/Macromedia/Adobe FreeHand documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libfreehand"
  url "http://dev-www.libreoffice.org/src/libfreehand/libfreehand-0.1.1.tar.xz"
  sha256 "ec6676d0c63f7feac7801a1fe18dd7abe9044b39c3882fc99b9afef39bdf1d30"
  revision 1

  bottle do
    cellar :any
    sha256 "1d223998ddc8b0b43a1046bd68a1ffa5a803e8915de39936a9fdf88892e5f14d" => :el_capitan
    sha256 "4fb596bf8a90d9bc7d807cef66017bebdd43f7018c2e821dcdd18aad5e9f9082" => :yosemite
    sha256 "1768d357e69076690af0622d9de6ca07de1c4e59e87fc7e3f96ec5b5e4f392ff" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libfreehand/libfreehand.h>
      int main() {
        libfreehand::FreeHandDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-I#{include}/libfreehand-0.1",
                    "-L#{Formula["librevenge"].lib}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-lfreehand-0.1"
    system "./test"
  end
end
