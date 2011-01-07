require 'formula'

class Aria2 <Formula
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.10.8/aria2-1.10.8.tar.bz2'
  md5 'cffc58c796e51cb4fea1a02deee2a750'
  homepage 'http://aria2.sourceforge.net/'

  def install
    fails_with_llvm "1.8.2 didn't work w/ LLVM"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
