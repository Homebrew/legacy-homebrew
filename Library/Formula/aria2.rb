require 'formula'

class Aria2 <Formula
  url 'http://downloads.sourceforge.net/project/aria2/stable/latest/aria2-1.8.2.tar.bz2'
  md5 'ec72262dbe4b4091dfe29d08f8e4d097'
  homepage 'http://aria2.sourceforge.net/'

  def install
    ENV.gcc_4_2 # 1.8.2 didn't work w/ LLVM on 10.6
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
