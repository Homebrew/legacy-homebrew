require 'formula'

class Clucene <Formula
  url 'http://downloads.sourceforge.net/project/clucene/clucene-core-stable/0.9.21/clucene-core-0.9.21.tar.bz2'
  homepage 'http://sourceforge.net/projects/clucene/'
  md5 '181cf9a827fd072717d9b09d1a1bda74'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
