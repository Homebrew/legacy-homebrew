require 'formula'

class Miniupnpc < Formula
  homepage 'http://miniupnp.free.fr'
  url 'http://miniupnp.free.fr/files/download.php?file=miniupnpc-1.6.20120125.tar.gz'
  md5 '61f136f1302add9d89d329a6c1e338ca'

  def install
    # Reported upstream:
    # http://miniupnp.tuxfamily.org/forum/viewtopic.php?t=978
    inreplace 'Makefile', "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)/$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
