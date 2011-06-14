require 'formula'

class Plotutils < Formula
  url 'ftp://mirrors.kernel.org/gnu/plotutils/plotutils-2.6.tar.gz'
  homepage 'http://www.gnu.org/software/plotutils/'
  md5 'c08a424bd2438c80a786a7f4b5bb6a40'

  def install
    ENV.x11 # enable libpng support
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-libplotter"
    system "make"
    system "make install"
  end
end
