require 'formula'

class Mpg321 < Formula
  url 'http://downloads.sourceforge.net/project/mpg321/mpg321/0.2.13/mpg321_0.2.13.tar.gz'
  homepage 'http://mpg321.sourceforge.net/'
  sha1 'e081688a084b16f56596c3ac4d3512e63a4b6269'

  depends_on 'mad'
  depends_on 'libid3tag'
  depends_on 'libao'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
