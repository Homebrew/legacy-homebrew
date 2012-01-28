require 'formula'

class Synfigstudio < Formula
  url 'http://downloads.sourceforge.net/project/synfig/synfigstudio/0.63.03/synfigstudio-0.63.03.tar.gz'
  homepage 'http://synfig.org'
  md5 'a166ff4917b0e058cae96e51aa273080'

  skip_clean :all # So modules will load

  depends_on 'gettext'
  depends_on 'libsigc++'
  depends_on 'gtkmm'
  depends_on 'etl'
  depends_on 'synfig'

  def install
    system "autoreconf --install --force"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
