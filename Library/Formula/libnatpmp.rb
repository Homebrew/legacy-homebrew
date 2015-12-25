class Libnatpmp < Formula
  desc "NAT port mapping protocol library"
  homepage "http://miniupnp.free.fr/libnatpmp.html"
  url "http://miniupnp.free.fr/files/download.php?file=libnatpmp-20130911.tar.gz"
  sha256 "a30d83b9175585cc0f5bff753ce7eb5d83aaecb6222ccac670ed759fea595d7d"

  bottle do
    cellar :any
    revision 1
    sha256 "56614258c625a9f98733b0fe0c451cf62725fd874b413f08e45ed93a8fdaa991" => :yosemite
    sha256 "66441cfb63476b8d74f5b90dccd434b081201cc7e900f7b2da4cba949cf40ef8" => :mavericks
    sha256 "e653484cb16a9732132635cf784bd7096d647277c017318316d8a442b559ca2a" => :mountain_lion
  end

  def install
    # Reported upstream:
    # http://miniupnp.tuxfamily.org/forum/viewtopic.php?t=978
    inreplace "Makefile", "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)/$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
