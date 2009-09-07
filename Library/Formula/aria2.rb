require 'brewkit'

class Aria2 <Formula
  @url='http://kent.dl.sourceforge.net/project/aria2/stable/aria2-1.5.2/aria2-1.5.2.tar.bz2'
  @homepage='http://aria2.sourceforge.net/'
  @md5='13ffefebdc4df4956721801fe74e01df'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
