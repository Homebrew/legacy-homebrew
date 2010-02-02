require 'formula'

class Ogmtools <Formula
  url 'http://www.bunkus.org/videotools/ogmtools/ogmtools-1.5.tar.bz2'
  homepage 'http://www.bunkus.org/videotools/ogmtools/'
  md5 '02d356e3d21d53b1d9715bab223d8996'

  depends_on 'libogg'
  depends_on 'libvorbis'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--mandir=#{prefix}/share"
    system "make install"
  end
end
