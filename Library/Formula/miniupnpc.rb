require 'formula'

class Miniupnpc < Formula
  homepage 'http://miniupnp.free.fr'
  url 'http://miniupnp.free.fr/files/download.php?file=miniupnpc-1.8.20130211.tar.gz'
  sha1 '51bf6cb12550db61908e8008431de88d6936c1ae'

  def install
    # Reported upstream:
    # http://miniupnp.tuxfamily.org/forum/viewtopic.php?t=978
    inreplace 'Makefile', "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)/$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
