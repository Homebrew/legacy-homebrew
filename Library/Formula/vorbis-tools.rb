require 'brewkit'

class VorbisTools <Formula
  @url='http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.2.0.tar.gz'
  @md5='df976d24e51ef3d87cd462edf747bf9a'
  @homepage='http://vorbis.com'

  depends_on 'ogg'
  depends_on 'vorbis'
  depends_on 'ao' => :optional
  depends_on 'ogg123' => :optional

  def install
    system "./configure --disable-debug --disable-nls --disable-dependency-tracking --prefix='#{prefix}'"
    # wtf?!
    inreplace 'ogg123/Makefile', '-arch ppc ppc64 i386 x86_64', '-arch i386'
    system "make install"
  end
end