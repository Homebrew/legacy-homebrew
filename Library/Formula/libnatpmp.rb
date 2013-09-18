require 'formula'

class Libnatpmp < Formula
  homepage 'http://miniupnp.free.fr'
  url 'http://miniupnp.free.fr/libnatpmp.html'
  sha1 'f2ec1ed22ae9f07b2cacf702d291858f13ae8781'

  def install
    # Reported upstream:
    # http://miniupnp.tuxfamily.org/forum/viewtopic.php?t=978
    inreplace 'Makefile', "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)/$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
