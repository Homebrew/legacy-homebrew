require 'brewkit'

class Theora <Formula
  url 'http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2'
  homepage 'http://www.theora.org/'
  md5 '292ab65cedd5021d6b7ddd117e07cd8e'

  depends_on 'libogg'
  depends_on 'libvorbis'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
