require 'formula'

class Liblcms <Formula
  url 'http://downloads.sourceforge.net/project/lcms/lcms/1.19/lcms-1.19.tar.gz'
  homepage 'http://www.littlecms.com/'
  md5 '8af94611baf20d9646c7c2c285859818'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
