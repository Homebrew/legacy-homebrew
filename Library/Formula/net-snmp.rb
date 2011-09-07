require 'formula'

class NetSnmp < Formula
  url 'http://downloads.sourceforge.net/project/net-snmp/net-snmp/5.6.1.1/net-snmp-5.6.1.1.tar.gz'
  homepage 'http://www.net-snmp.org/'
  md5 '79e2b9cac947567a01ae2cc67ad8fe53'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-persistent-directory=/var/db/net-snmp",
                          "--with-defaults",
                          "--without-rpm",
                          "--with-mib-modules=host ucd-snmp/diskio",
                          "--with-out-mib-modules=mibII/icmp",
                          "--without-kmem-usage"
    system "make"
    system "make install"
  end
end
