require 'formula'

class Miniupnpc < Formula
  homepage 'http://miniupnp.free.fr'
  url 'http://miniupnp.free.fr/files/download.php?file=miniupnpc-1.8.20130503.tar.gz'
  sha1 '260f3304246fde1833b8aa344892d950199a32a6'

  def install
    # Reported upstream:
    # http://miniupnp.tuxfamily.org/forum/viewtopic.php?t=978
    inreplace 'Makefile', "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)/$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
