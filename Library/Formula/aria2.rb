require 'formula'

class Aria2 <Formula
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.10.6/aria2-1.10.6.tar.bz2'
  md5 '34029f86d9355872cf4b86267d3513c7'
  homepage 'http://aria2.sourceforge.net/'

  def install
    fails_with_llvm "1.8.2 didn't work w/ LLVM"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
