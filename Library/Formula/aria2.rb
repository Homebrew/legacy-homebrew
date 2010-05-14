require 'formula'

class Aria2 <Formula
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.9.3/aria2-1.9.3.tar.bz2'
  md5 'b227e3fe4ffe20ca4215622bef827bd1'
  homepage 'http://aria2.sourceforge.net/'

  def install
    ENV.gcc_4_2 # 1.8.2 didn't work w/ LLVM on 10.6
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
