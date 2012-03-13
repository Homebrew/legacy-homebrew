require 'formula'

class NetSnmp < Formula
  homepage 'http://www.net-snmp.org/'
  url 'http://sourceforge.net/projects/net-snmp/files/net-snmp/5.7.1/net-snmp-5.7.1.tar.gz'
  md5 'c95d08fd5d93df0c11a2e1bdf0e01e0b'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-persistent-directory=#{var}/db/net-snmp",
                          "--with-defaults",
                          "--without-rpm",
                          "--with-mib-modules=host ucd-snmp/diskio",
                          "--with-out-mib-modules=mibII/icmp",
                          "--without-kmem-usage"
    system "make"
    system "make install"
  end
end
