require 'formula'

class NoBdb5 < Requirement
  def message; <<-EOS.undent
    This software can fail to compile when Berkeley-DB 5.x is installed.
    You may need to try:
      brew unlink berkeley-db
      brew install dsniff
      brew link berkeley-db
    EOS
  end
  def satisfied?
    f = Formula.factory("berkeley-db")
    not f.installed?
  end
end

class Dsniff < Formula
  url 'http://monkey.org/~dugsong/dsniff/beta/dsniff-2.4b1.tar.gz'
  homepage 'http://monkey.org/~dugsong/dsniff/'
  md5 '2f761fa3475682a7512b0b43568ee7d6'

  depends_on NoBdb5.new
  depends_on 'libnet'
  depends_on 'libnids'

  def patches
  {:p0 => [
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-arpspoof.c.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-dnsspoof.c.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-filesnarf.c.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-macof.c.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-pcaputil.c",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-record.c.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-sshcrypto.c",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-sshmitm.c.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-sshow.c.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-tcp_raw.c.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-tcp_raw.h.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-tcpkill.c.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-tcpnice.c.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-trigger.c.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-trigger.h.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-urlsnarf.c.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-webmitm.c.diff",
    "https://trac.macports.org/export/90933/trunk/dports/net/dsniff-devel/files/patch-webspy.c.diff"
  ]}
  end

  def install
    ENV.append 'CFLAGS', "-DBIND_8_COMPAT"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libnet=#{HOMEBREW_PREFIX}",
                          "--with-libnids=#{HOMEBREW_PREFIX}"
    system "make"
    system "make install"
  end
end
