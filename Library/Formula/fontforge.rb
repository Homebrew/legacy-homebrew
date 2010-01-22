require 'formula'

class Fontforge <Formula
  url 'http://downloads.sourceforge.net/project/fontforge/fontforge-source/fontforge_full-20100501.tar.bz2'
  homepage 'http://fontforge.sourceforge.net'
  md5 '5f3d20d645ec1aa2b7b4876386df8717'

  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'potrace'

  def install
    system "./configure", "--enable-double",
                          "--without-freetype-bytecode", "--without-python",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats
    "'fontforge' is an X11 application."
  end
end
