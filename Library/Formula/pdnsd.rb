require 'formula'

class Pdnsd < Formula
  homepage 'http://members.home.nl/p.a.rombouts/pdnsd/'
  url 'http://members.home.nl/p.a.rombouts/pdnsd/releases/pdnsd-1.2.9a-par.tar.gz'
  version '1.2.9a-par'
  sha1 '55d8fd71e2f291a3ead53c8097729fa95264bea9'

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
