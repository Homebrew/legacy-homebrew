require 'formula'

class Libgdiplus < Formula
  url 'http://ftp.novell.com/pub/mono/sources/libgdiplus/libgdiplus-2.6.tar.bz2'
  homepage 'http://www.mono-project.com/Libgdiplus'
  md5 '9107b4429fdafde914bd23405544c58d'

  depends_on 'gettext'
  depends_on 'libtiff'
  depends_on 'libexif'
  depends_on 'glib'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
