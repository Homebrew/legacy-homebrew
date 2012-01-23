require 'formula'

class Hping < Formula
  url 'http://www.hping.org/hping3-20051105.tar.gz'
  homepage 'http://www.hping.org/'
  md5 'ca4ea4e34bcc2162aedf25df8b2d1747'
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

    inreplace 'Makefile' do |s|
      s.change_make_var! "INSTALL_PATH", prefix
      s.change_make_var! "INSTALL_MANPATH", man
    end

    # Target folders need to exist before installing
    sbin.mkpath
    man8.mkpath
    system "make install"
  end
end
