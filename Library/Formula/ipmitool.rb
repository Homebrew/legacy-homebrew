require 'formula'

class Ipmitool < Formula
  homepage 'http://ipmitool.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.13/ipmitool-1.8.13.tar.bz2'
  sha1 '22254a2b814c8cd323866a4dd835e390521c1dfa'

  def install
    # tracking upstream: http://sourceforge.net/p/ipmitool/feature-requests/47/
    # fix build errors w/ clang
    inreplace 'include/ipmitool/ipmi_user.h', 'HAVE_PRAGMA_PACK', 'DISABLE_PRAGMA_PACK'
    # undefined non-posix symbols
    inreplace 'src/plugins/serial/serial_basic.c', 'IUCLC', '0'
    inreplace 'src/plugins/serial/serial_basic.c', 'TCFLSH', '0'
    inreplace 'src/plugins/serial/serial_terminal.c', 'IUCLC', '0'
    inreplace 'src/plugins/serial/serial_terminal.c', 'TCFLSH', '0'

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
