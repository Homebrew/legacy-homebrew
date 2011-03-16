require 'formula'

class NetSnmp < Formula
  url 'http://downloads.sourceforge.net/project/net-snmp/net-snmp/5.6/net-snmp-5.6.tar.gz'
  homepage 'http://www.net-snmp.org/'
  md5 '89b3a7a77e68daef925abee43a3f7018'

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
