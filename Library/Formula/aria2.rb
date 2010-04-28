require 'formula'

class Aria2 <Formula
  url 'http://downloads.sourceforge.net/project/aria2/stable/latest/aria2-1.9.2.tar.bz2'
  md5 '70ba78851ea62d2f694fb65160d884ad'
  homepage 'http://aria2.sourceforge.net/'

  def install
    ENV.gcc_4_2 # 1.8.2 didn't work w/ LLVM on 10.6
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
