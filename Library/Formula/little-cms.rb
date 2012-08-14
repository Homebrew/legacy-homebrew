require 'formula'

class LittleCms < Formula
  url 'http://sourceforge.net/projects/lcms/files/lcms/1.19/lcms-1.19.tar.gz'
  homepage 'http://www.littlecms.com/'
  md5 '8af94611baf20d9646c7c2c285859818'

  depends_on 'jpeg' => :optional
  depends_on 'libtiff' => :optional

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make install"
  end
end
