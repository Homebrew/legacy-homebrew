require 'formula'

class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage 'http://ipmitool.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.15/ipmitool-1.8.15.tar.bz2'
  sha1 '2c9c5d7c5a285586df508ad933577f275684353a'

  depends_on "openssl"

  def install
    # tracking upstream: http://sourceforge.net/p/ipmitool/feature-requests/47/
    # fix build errors w/ clang
    inreplace 'include/ipmitool/ipmi_user.h', 'HAVE_PRAGMA_PACK', 'DISABLE_PRAGMA_PACK'
    # s6_addr16 is not available in Mac OS X
    inreplace 'src/plugins/ipmi_intf.c', 's6_addr16', 's6_addr'

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
