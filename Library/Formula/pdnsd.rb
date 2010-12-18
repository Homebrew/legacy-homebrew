require 'formula'

class Pdnsd <Formula
  url 'http://www.phys.uu.nl/~rombouts/pdnsd/releases/pdnsd-1.2.8-par.tar.gz'
  version '1.2.8-par'
  homepage 'http://www.phys.uu.nl/~rombouts/pdnsd.html'
  md5 '779c5d19576e561fbf2455de435e5597'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "--with-cachedir=#{var}/cache/pdnsd"
    system "make install"
  end
end
