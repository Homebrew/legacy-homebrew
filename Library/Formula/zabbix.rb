require 'formula'

class MySqlInstalled < Requirement
  def message; <<-EOS.undent
    MySQL is required to install.

    You can install this with Homebrew using:
      brew install mysql-connector-c
        For MySQL client libraries only.

      brew install mysql
        For MySQL server.

    Or you can use an official installer from:
      http://dev.mysql.com/downloads/mysql/
    EOS
  end

  def satisfied?
    which 'mysql_config'
  end

  def fatal?
    true
  end
end

class Zabbix < Formula
  homepage 'http://www.zabbix.com/'
  url 'http://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.0.2/zabbix-2.0.2.tar.gz'
  sha1 'aaa678bc6abc6cb2b174e599108ad19f187047c9'

  depends_on MySqlInstalled.new
  depends_on 'fping'
  depends_on 'libssh2'

  def install
    which_mysql = which('mysql_config') || "#{HOMEBREW_PREFIX}/bin/mysql_config"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-server",
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
