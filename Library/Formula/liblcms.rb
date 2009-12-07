require 'formula'

class Liblcms <Formula
  url 'http://www.littlecms.com/lcms-1.18a.tar.gz'
  homepage 'http://www.littlecms.com/'
  md5 'f4abfe1c57ea3f633c2e9d034e74e3e8'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
