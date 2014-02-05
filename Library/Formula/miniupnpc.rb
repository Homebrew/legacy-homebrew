require 'formula'

class Miniupnpc < Formula
  homepage 'http://miniupnp.tuxfamily.org'
  url 'http://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-1.8.20131007.tar.gz'
  sha1 'e2881e9583e90d6706abe0663330f46579efc64a'

  def install
    # Reported upstream:
    # http://miniupnp.tuxfamily.org/forum/viewtopic.php?t=978
    inreplace 'Makefile', "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)/$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
