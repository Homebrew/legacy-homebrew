require 'formula'

class Plotutils < Formula
  url 'http://ftpmirror.gnu.org/plotutils/plotutils-2.6.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/plotutils/plotutils-2.6.tar.gz'
  homepage 'http://www.gnu.org/software/plotutils/'
  md5 'c08a424bd2438c80a786a7f4b5bb6a40'

  depends_on :libpng

  def install
    # Fix usage of libpng to be 1.5 compatible
    inreplace 'libplot/z_write.c', 'png_ptr->jmpbuf', 'png_jmpbuf (png_ptr)'

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-libplotter"
    system "make"
    system "make install"
  end
end
