class Plotutils < Formula
  desc "GNU tools based on libplot, a multi-format 2-D vector graphics library"
  homepage "https://www.gnu.org/software/plotutils/"
  url "http://ftpmirror.gnu.org/plotutils/plotutils-2.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/plotutils/plotutils-2.6.tar.gz"
  sha256 "4f4222820f97ca08c7ea707e4c53e5a3556af4d8f1ab51e0da6ff1627ff433ab"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "b734cdcbc7ce11c4a716bc96ee7671f3883a5d41dadceac28d994ad2c20292f9" => :el_capitan
    sha256 "fae89f252628820ac83a0896fa022b1c08cacca6e6234b2fb23c10554f424fd3" => :yosemite
    sha256 "e51b4b5c367e8f9ec533f54e20c9df0b887818ee35c4cde19ba8feb73d4d2ff2" => :mavericks
    sha256 "f77398849e9a064feee52712c8c71a60e07dbc7a2d00967ed584e046ff4bc4d7" => :mountain_lion
  end

  depends_on "libpng"
  depends_on :x11 => :optional

  def install
    # Fix usage of libpng to be 1.5 compatible
    inreplace "libplot/z_write.c", "png_ptr->jmpbuf", "png_jmpbuf (png_ptr)"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-libplotter
    ]

    args << "--with-x" if build.with? "x11"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert pipe_output("#{bin}/graph -T ps", "0.0 0.0\n1.0 0.2\n").start_with?("")
  end
end
