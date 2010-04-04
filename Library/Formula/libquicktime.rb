require 'formula'

class Libquicktime <Formula

  url 'http://downloads.sourceforge.net/project/libquicktime/libquicktime/1.1.5/libquicktime-1.1.5.tar.gz'
  homepage 'http://libquicktime.sourceforge.net/'
  md5 '0fd45b3deff0317c2f85a34b1b106acf'

  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'jpeg' => :optional
  depends_on 'lame' => :optional
  depends_on 'schroedinger' => :optional
  depends_on 'ffmpeg' => :optional
  depends_on 'libvorbis' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}", "--without-doxygen"
    system "make"
    system "make install"
  end

end
