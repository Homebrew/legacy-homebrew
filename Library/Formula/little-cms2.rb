require 'formula'

class LittleCms2 < Formula
  url 'http://sourceforge.net/projects/lcms/files/lcms/2.3/lcms2-2.3.tar.gz'
  homepage 'http://www.littlecms.com/'
  md5 '327348d67c979c88c2dec59a23a17d85'

  depends_on 'jpeg' => :optional
  depends_on 'libtiff' => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
