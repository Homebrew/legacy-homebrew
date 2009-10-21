require 'formula'

class Aria2 <Formula
  @url='http://downloads.sourceforge.net/project/aria2/stable/latest/aria2-1.6.2.tar.bz2'
  @homepage='http://aria2.sourceforge.net/'
  @md5='aa94152c01a11e75b77a6be6c15e81ff'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
