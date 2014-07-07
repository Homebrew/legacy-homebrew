require 'formula'

class Libnatpmp < Formula
  homepage 'http://miniupnp.free.fr/libnatpmp.html'
  url 'http://miniupnp.free.fr/files/download.php?file=libnatpmp-20130911.tar.gz'
  sha1 'f2ec1ed22ae9f07b2cacf702d291858f13ae8781'

  bottle do
    cellar :any
    sha1 "e6d42daee6bdd2d0854a2402cde606a880c54bbf" => :mavericks
    sha1 "380a32ba2f2b7383784693a4fc41968e94aa2356" => :mountain_lion
    sha1 "b106068d2535580dc36de4943aef2ed48014c2e9" => :lion
  end

  def install
    # Reported upstream:
    # http://miniupnp.tuxfamily.org/forum/viewtopic.php?t=978
    inreplace 'Makefile', "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)/$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
