class Libfreehand < Formula
  desc "Interpret and import Aldus/Macromedia/Adobe FreeHand documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libfreehand"
  url "http://dev-www.libreoffice.org/src/libfreehand/libfreehand-0.1.1.tar.xz"
  sha256 "ec6676d0c63f7feac7801a1fe18dd7abe9044b39c3882fc99b9afef39bdf1d30"

  bottle do
    cellar :any
    sha256 "9179aa1f2f70931d95a632f88b90dab2dae1a03d85ccf6c4cdb191258844e158" => :yosemite
    sha256 "eb8d65c58a1138f638fd9daa375af93cd50d18fdb41b3031ba860271779f9be4" => :mavericks
    sha256 "1d905f049eb5471b15f2af24cd7a8ae909574aedacc20231795e927123a7d926" => :mountain_lion
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
