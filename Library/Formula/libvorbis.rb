require 'brewkit'

class Libvorbis <Formula
  @url='http://downloads.xiph.org/releases/vorbis/libvorbis-1.2.2rc1.tar.bz2'
  @md5='6a7086ee666b8c62e122d29d107f7bec'
  @homepage='http://vorbis.com'

  depends_on 'libogg'

  def install
    system "./configure --enable-docs --disable-debug --disable-dependency-tracking --prefix='#{prefix}'"
    system "make install"
  end
end