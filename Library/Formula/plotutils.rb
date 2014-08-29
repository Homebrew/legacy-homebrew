require 'formula'

class Plotutils < Formula
  homepage 'http://www.gnu.org/software/plotutils/'
  url 'http://ftpmirror.gnu.org/plotutils/plotutils-2.6.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/plotutils/plotutils-2.6.tar.gz'
  sha1 '7921301d9dfe8991e3df2829bd733df6b2a70838'
  revision 1

  depends_on 'libpng'
  depends_on :x11 => :optional

  def install
    # Fix usage of libpng to be 1.5 compatible
    inreplace 'libplot/z_write.c', 'png_ptr->jmpbuf', 'png_jmpbuf (png_ptr)'

    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-libplotter"]
    args << "--with-x" if build.with? "x11"

    system "./configure", *args
    system "make"
    system "make install"
  end
end
