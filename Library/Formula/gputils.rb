require 'formula'

class Gputils <Formula
  url 'http://downloads.sourceforge.net/project/gputils/gputils/0.13.7/gputils-0.13.7.tar.gz'
  homepage 'http://gputils.sourceforge.net/'
  md5 '242e33919e9c318d6ac58b6db291d20e'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
