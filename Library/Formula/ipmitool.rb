class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "http://ipmitool.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.16/ipmitool-1.8.16.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/ipmitool/ipmitool_1.8.16.orig.tar.bz2"
  sha256 "3c5da6b067abf475bc24685120ec79f6e4ef6b3ea606aaa267e462023861223e"

  depends_on "openssl"

  def install
    # Required to get NI_MAXHOST and NI_MAXSERV defined in /usr/include/netdb.h, see
    # https://sourceforge.net/p/ipmitool/bugs/418
    inreplace "src/plugins/ipmi_intf.c", "#define _GNU_SOURCE 1", "#define _GNU_SOURCE 1\n#define _DARWIN_C_SOURCE 1"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-intf-usb"
    system "make", "install"
  end

  test do
    # Test version print out
    system bin/"ipmitool", "-V"
  end
end
