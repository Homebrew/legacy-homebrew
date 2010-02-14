require 'formula'

class Clutter <Formula
  url 'http://www.clutter-project.org/sources/clutter/1.0/clutter-1.0.8.tar.bz2'
  homepage 'http://www.clutter-project.org/'
  md5 '687f9699ea5590091282034a936c6dc7'

  depends_on 'pango'
  depends_on 'glib'
  depends_on 'pkg-config'
  depends_on 'intltool'
  depends_on 'gettext'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-flavour=osx", "--with-imagebackend=quartz"
    system "make install"
  end
end
