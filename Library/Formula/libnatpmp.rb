require 'formula'

class Libnatpmp < Formula
  homepage 'http://miniupnp.free.fr/libnatpmp.html'
  url 'http://miniupnp.free.fr/files/download.php?file=libnatpmp-20130911.tar.gz'
  sha1 'f2ec1ed22ae9f07b2cacf702d291858f13ae8781'

  bottle do
    cellar :any
    revision 1
    sha1 "75db0fd068b01482b95c315751bb316d16cb69b0" => :yosemite
    sha1 "afe8b7fe9baabfa890989697566d20eaa1542c86" => :mavericks
    sha1 "0f1274f31f8a718d640e72327ecc814af16edef7" => :mountain_lion
  end

  def install
    # Reported upstream:
    # http://miniupnp.tuxfamily.org/forum/viewtopic.php?t=978
    inreplace 'Makefile', "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)/$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
