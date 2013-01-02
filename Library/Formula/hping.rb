require 'formula'

class Hping < Formula
  homepage 'http://www.hping.org/'
  url 'http://www.hping.org/hping3-20051105.tar.gz'
  sha1 'e13d27e14e7f90c2148a9b00a480781732fd351e'
  version '3.20051105'

  def patches
    {:p0 => [
      # MacPorts patches: http://trac.macports.org/browser/trunk/dports/net/hping3
      "https://trac.macports.org/export/70033/trunk/dports/net/hping3/files/patch-libpcap_stuff.c.diff",
      "https://trac.macports.org/export/70033/trunk/dports/net/hping3/files/patch-ars.c.diff",
      "https://trac.macports.org/export/70033/trunk/dports/net/hping3/files/patch-sendip.c.diff",
      "https://trac.macports.org/export/70033/trunk/dports/net/hping3/files/patch-Makefile.in.diff",
      "https://trac.macports.org/export/70033/trunk/dports/net/hping3/files/patch-bytesex.h.diff"
    ]}
  end

  def install
    # Compile fails with tcl support; TCL on OS X is 32-bit only
    system "./configure", "--no-tcl"

    # Target folders need to exist before installing
    sbin.mkpath
    man8.mkpath
    system "make", "CC=#{ENV.cc}",
                   "COMPILE_TIME=#{ENV.cflags}",
                   "INSTALL_PATH=#{prefix}",
                   "INSTALL_MANPATH=#{man}",
                   "install"
  end
end
