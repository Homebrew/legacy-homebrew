require 'formula'

class Aria2 <Formula
  @url='http://downloads.sourceforge.net/project/aria2/stable/latest/aria2-1.8.0.tar.bz2'
  @homepage='http://aria2.sourceforge.net/'
  @md5='13944c95529de6846f0ab9ba09c53e3e'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
