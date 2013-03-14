require 'formula'

class Zzuf < Formula
  homepage 'http://caca.zoy.org/wiki/zzuf'
  url 'http://caca.zoy.org/files/zzuf/zzuf-0.13.tar.gz'
  sha1 '19f904d63d045194885639c381a607ca86a319b5'

  def patches
    # Fix OS X-specific bug in zzuf 0.13; see https://trac.macports.org/ticket/29157
    # This has been fixed upstream and should be included in the next release.
    { :p3 =>
      'https://trac.macports.org/export/78051/trunk/dports/security/zzuf/files/patch-src-libzzuf-lib--mem.c.diff'
    }
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
