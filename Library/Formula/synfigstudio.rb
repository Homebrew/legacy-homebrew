require 'formula'

class Synfigstudio < Formula
  homepage 'http://synfig.org'
  url 'http://downloads.sourceforge.net/project/synfig/synfigstudio/0.63.05/synfigstudio-0.63.05.tar.gz'
  sha1 '3e8f590b2b1b3cfdef7ecc898fcef3c9254f21e2'

  skip_clean :all # So modules will load

  depends_on 'gettext'
  depends_on 'libsigc++'
  depends_on 'gtkmm'
  depends_on 'etl'
  depends_on 'synfig'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
