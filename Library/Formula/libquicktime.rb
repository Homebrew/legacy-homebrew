require 'formula'

class Libquicktime < Formula
  url 'http://downloads.sourceforge.net/project/libquicktime/libquicktime/1.2.3/libquicktime-1.2.3.tar.gz'
  homepage 'http://libquicktime.sourceforge.net/'
  md5 '9a82a1546408605ea8337b3a7c78786e'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'jpeg' => :optional
  depends_on 'lame' => :optional
  depends_on 'schroedinger' => :optional
  depends_on 'ffmpeg' => :optional
  depends_on 'libvorbis' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gpl",
                          "--without-doxygen"
    system "make"
    system "make install"
  end
end
