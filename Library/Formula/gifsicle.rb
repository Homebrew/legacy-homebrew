require 'formula'

class Gifsicle < Formula
  url 'http://www.lcdf.org/gifsicle/gifsicle-1.64.tar.gz'
  homepage 'http://www.lcdf.org/gifsicle/'
  md5 'dabe9ee0d6d9cea099d9a7e6ecdcc443'

  def install
    ENV.x11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-all"
    system "make install"
  end
end
