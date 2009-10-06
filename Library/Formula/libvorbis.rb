require 'brewkit'

class Libvorbis <Formula
  @url='http://downloads.xiph.org/releases/vorbis/libvorbis-1.2.3.tar.bz2'
  @md5='67beb237faf97d74782ec7071756b2b6'
  @homepage='http://vorbis.com'

  depends_on 'libogg'

  def install
    system "./configure --enable-docs --disable-debug --disable-dependency-tracking --prefix='#{prefix}'"
    system "make install"
  end
end