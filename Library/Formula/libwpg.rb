require 'formula'

class Libwpg < Formula
  homepage 'http://libwpg.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/libwpg/libwpg/libwpg-0.2.0/libwpg-0.2.0.tar.bz2'
  sha1 '34a692566bda66488f83c635774d1bd92cee0fdf'

  depends_on 'libwpd'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # Separate steps or install can fail due to folders not existing
    system "make"
    ENV.j1
    system "make install"
  end
end
