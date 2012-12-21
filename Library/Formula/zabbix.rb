require 'formula'

class Zabbix < Formula
  homepage 'http://www.zabbix.com/'
  url 'http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/2.0.4/zabbix-2.0.4.tar.gz'
  sha1 '26ffd4616a96434b3c357146780f66058f6fbd80'

  depends_on :mysql
  depends_on 'fping'
  depends_on 'libssh2'

  def install
    which_mysql = which('mysql_config') || "#{HOMEBREW_PREFIX}/bin/mysql_config"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-server",
                          "--enable-proxy",
                          "--enable-agent",
                          "--with-mysql=#{which_mysql}",
                          "--enable-ipv6",
                          "--with-net-snmp",
                          "--with-libcurl",
                          "--with-ssh2"

    system "make install"
    (share/'zabbix').install 'frontends/php', 'database/mysql'
  end

  def caveats; <<-EOS.undent
    Please read the fine manual for post-install instructions:
      http://www.zabbix.com/documentation/2.0/manual

    Or just use Puppet:
      https://github.com/bjoernalbers/puppet-zabbix_osx
    EOS
  end

  def test
    system "#{sbin}/zabbix_agent", "--print"
  end
end
