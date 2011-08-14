require 'formula'

class DsniffDevel < Formula
  url 'http://monkey.org/~dugsong/dsniff/beta/dsniff-2.4b1.tar.gz'
  homepage 'http://monkey.org/~dugsong/dsniff/'
  md5 '2f761fa3475682a7512b0b43568ee7d6'

  def patches
      { :p0 => ["http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-arpspoof.c.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-dnsspoof.c.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-filesnarf.c.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-macof.c.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-pcaputil.c",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-record.c.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-sshcrypto.c",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-sshmitm.c.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-sshow.c.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-tcp_raw.c.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-tcp_raw.h.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-tcpkill.c.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-tcpnice.c.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-trigger.c.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-trigger.h.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-urlsnarf.c.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-webmitm.c.diff",
      "http://www.localhost.lu/macports/ports/net/dsniff-devel/files/patch-webspy.c.diff"]}
  end

  depends_on 'libnet'
  depends_on 'libnids'

  def install
    ENV.append 'CFLAGS', "-DBIND_8_COMPAT"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-libnet=/usr/local/Cellar/libnet/1.1/", "--with-libnids=/usr/local/Cellar/libnids/1.24/", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
