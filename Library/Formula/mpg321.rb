require 'formula'

class Mpg321 < Formula
  url 'http://downloads.sourceforge.net/project/mpg321/mpg321/0.2.13/mpg321_0.2.13.tar.gz'
  homepage 'http://mpg321.sourceforge.net/'
  md5 'fa542f9c638d8319b13a0a1647722bc5'

  depends_on 'mad'
  depends_on 'libid3tag'
  depends_on 'libao'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
