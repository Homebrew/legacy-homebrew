require 'formula'

class Ggobi < Formula
  url 'http://www.ggobi.org/downloads/ggobi-2.1.9.tar.bz2'
  homepage 'http://www.ggobi.org'
  md5 'b579861f157dfc6c5669604859352eb4'

  depends_on 'gtk+'
  depends_on 'glib'
  depends_on 'atk'
  depends_on 'cairo'
  depends_on 'fontconfig'
  depends_on 'pango'
  depends_on 'gettext'

  def install
    # Necessary for ggobi to build - based on patch from MacPorts
    # See: https://trac.macports.org/export/64669/trunk/dports/science/ggobi/files/patch-src-texture.diff
    inreplace 'src/texture.c', 'psort', 'p_sort'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-all-plugins", "--prefix=#{prefix}"
    system "make install"
  end
end
