require 'formula'

class Aria2 <Formula
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.10.0/aria2-1.10.0.tar.bz2'
  md5 '1386df9b2003f42695062a0e1232e488'
  homepage 'http://aria2.sourceforge.net/'

  def install
    fails_with_llvm "1.8.2 didn't work w/ LLVM"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
