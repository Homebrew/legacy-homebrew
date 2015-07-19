class Plotutils < Formula
  desc "GNU tools based on libplot, a multi-format 2-D vector graphics library"
  homepage "https://www.gnu.org/software/plotutils/"
  url "http://ftpmirror.gnu.org/plotutils/plotutils-2.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/plotutils/plotutils-2.6.tar.gz"
  sha256 "4f4222820f97ca08c7ea707e4c53e5a3556af4d8f1ab51e0da6ff1627ff433ab"
  revision 1

  bottle do
    cellar :any
    sha1 "e77297eb70e65c76f79064fe0b1649200812d90d" => :yosemite
    sha1 "26e33cc79cfe51e36c3952ea4f541183fbb0605b" => :mavericks
    sha1 "224bcf0989a50cc12c2eb0890b81c733926e695c" => :mountain_lion
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
