require 'brewkit'

class Theora <Formula
  url 'http://downloads.xiph.org/releases/theora/libtheora-1.1.0.tar.bz2'
  homepage 'http://www.theora.org/'
  md5 'd0f83cf7f13e2b3bd068a858ca1398ad'

  depends_on 'libogg'
  depends_on 'libvorbis'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
