require 'formula'

class SynfigStudio <Formula
  url 'https://downloads.sourceforge.net/project/synfig/synfigstudio/0.62.02/synfigstudio-0.62.02.tar.gz'
  homepage 'http://synfig.org'
  md5 ''

  depends_on 'etl'
  depends_on 'synfig'
  depends_on 'gtkmm'
  depends_on 'gtk+'
  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
