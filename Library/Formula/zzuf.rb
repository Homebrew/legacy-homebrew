require 'formula'

class Zzuf < Formula
  url 'http://caca.zoy.org/files/zzuf/zzuf-0.13.tar.gz'
  homepage 'http://caca.zoy.org/wiki/zzuf'
  md5 '74579c429f9691f641a14f408997d42d'

  def patches
  	# Fix OS X-specific bug in zzuf 0.13; see https://trac.macports.org/ticket/29157
  	{ :p3 => 'https://trac.macports.org/export/78051/trunk/dports/security/zzuf/files/patch-src-libzzuf-lib--mem.c.diff'}
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
