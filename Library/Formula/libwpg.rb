require 'formula'

class Libwpg <Formula
  url 'http://downloads.sourceforge.net/project/libwpg/libwpg/libwpg-0.1.3/libwpg-0.1.3.tar.bz2'
  md5 '1069ad84fdf65f1c47b63b639137613f'
  homepage 'http://libwpg.sourceforge.net/'

  depends_on 'libwpd'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
