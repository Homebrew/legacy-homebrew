require 'brewkit'

class Faad2 <Formula
  url 'http://surfnet.dl.sourceforge.net/project/faac/faad2-src/faad2-2.7/faad2-2.7.tar.bz2'
  md5 '4c332fa23febc0e4648064685a3d4332'
  homepage 'http://www.audiocoding.com/faad2.html'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
