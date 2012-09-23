require 'formula'

class Miniupnpc < Formula
  homepage 'http://miniupnp.free.fr'
  url 'http://miniupnp.free.fr/files/download.php?file=miniupnpc-1.7.20120714.tar.gz'
  sha1 'b7f68de24e75c0c2538d9936e7418fc1ae4df72b'

  def install
    # Reported upstream:
    # http://miniupnp.tuxfamily.org/forum/viewtopic.php?t=978
    inreplace 'Makefile', "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)/$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
