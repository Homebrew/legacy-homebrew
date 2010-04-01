require 'formula'

class Aria2 <Formula
  url 'http://downloads.sourceforge.net/project/aria2/stable/latest/aria2-1.9.0.tar.bz2'
  md5 '2059bc4a3f4ed155020f0f24e62d79e0'
  homepage 'http://aria2.sourceforge.net/'

  def install
    ENV.gcc_4_2 # 1.8.2 didn't work w/ LLVM on 10.6
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
