require 'formula'

class Gifsicle < Formula
  homepage 'http://www.lcdf.org/gifsicle/'
  url 'http://www.lcdf.org/gifsicle/gifsicle-1.77.tar.gz'
  sha1 '29ac22a9aa1a22ed85e4df90668c72d08d89c8b0'

  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-all"
    system "make install"
  end
end
