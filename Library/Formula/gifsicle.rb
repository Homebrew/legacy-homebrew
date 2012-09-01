require 'formula'

class Gifsicle < Formula
  homepage 'http://www.lcdf.org/gifsicle/'
  url 'http://www.lcdf.org/gifsicle/gifsicle-1.67.tar.gz'
  md5 '77fe0eea7844243489e9d87af91168ed'

  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-all"
    system "make install"
  end
end
