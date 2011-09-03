require 'formula'

class Synfigstudio < Formula
  url 'http://downloads.sourceforge.net/project/synfig/synfigstudio/0.62.02/synfigstudio-0.62.02.tar.gz'
  homepage 'http://synfig.org'
  md5 '4b06f813e497072f01779f554e34c315'

  skip_clean :all # So modules will load

  depends_on 'gettext'
  depends_on 'libsigc++'
  depends_on 'etl'
  depends_on 'synfig'
  depends_on 'gtkmm'

  def install
    system "autoreconf --install --force"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
