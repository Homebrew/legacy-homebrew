require 'formula'

class Miniupnpc < Formula
  homepage 'http://miniupnp.free.fr'
  url 'http://miniupnp.free.fr/files/download.php?file=miniupnpc-1.7.20120830.tar.gz'
  sha1 '20ec14d0abb4b9c47b0a3afc37f9f6a374c0b767'

  def install
    # Reported upstream:
    # http://miniupnp.tuxfamily.org/forum/viewtopic.php?t=978
    inreplace 'Makefile', "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)/$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
