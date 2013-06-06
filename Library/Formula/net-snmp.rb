require 'formula'

class NetSnmp < Formula
  homepage 'http://www.net-snmp.org/'
  url 'http://sourceforge.net/projects/net-snmp/files/net-snmp/5.7.2/net-snmp-5.7.2.tar.gz'
  sha1 'c493027907f32400648244d81117a126aecd27ee'

  def install
    system "./configure", "--disable-debugging",
                          "--prefix=#{prefix}",
                          "--enable-ipv6",
                          "--with-defaults",
                          "--with-persistent-directory=#{var}/db/net-snmp",
                          "--with-logfile=#{var}/log/snmpd.log",
                          "--with-mib-modules=host ucd-snmp/diskio",
                          "--without-rpm",
                          "--without-kmem-usage",
                          "--disable-embedded-perl",
                          "--without-perl-modules"
    system "make"
    system "make install"
  end
end
