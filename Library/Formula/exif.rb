require 'formula'

class Exif <Formula
  url 'http://downloads.sourceforge.net/project/libexif/exif/0.6.19/exif-0.6.19.tar.bz2'
  homepage 'http://libexif.sourceforge.net/'
  md5 '75f0dd6f9f2d128261721c0896e0b324'

  depends_on 'pkg-config'
  depends_on 'popt'
  depends_on 'libexif'
  depends_on 'gettext'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
