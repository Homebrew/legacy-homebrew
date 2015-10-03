class Libnatpmp < Formula
  desc "NAT port mapping protocol library"
  homepage "http://miniupnp.free.fr/libnatpmp.html"
  url "http://miniupnp.free.fr/files/download.php?file=libnatpmp-20130911.tar.gz"
  sha256 "a30d83b9175585cc0f5bff753ce7eb5d83aaecb6222ccac670ed759fea595d7d"

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
    inreplace "Makefile", "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)/$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
