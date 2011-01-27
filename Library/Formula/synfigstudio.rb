require 'formula'

class Synfigstudio <Formula
  url 'https://downloads.sourceforge.net/project/synfig/synfigstudio/0.62.02/synfigstudio-0.62.02.tar.gz'
  homepage 'http://synfig.org'
  md5 ''

  depends_on 'etl'
  depends_on 'synfig'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
