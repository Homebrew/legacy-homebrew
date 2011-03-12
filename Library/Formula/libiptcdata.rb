require 'formula'

class Libiptcdata <Formula
  url 'http://sourceforge.net/projects/libiptcdata/files/libiptcdata/1.0.4/libiptcdata-1.0.4.tar.gz'
  homepage 'http://libiptcdata.sourceforge.net/'
  md5 'af886556ecb129b694f2d365d03d95a8'

  depends_on 'gettext'
  depends_on 'libiconv'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
