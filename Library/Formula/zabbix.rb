require 'formula'

def mysql?
  build.include? 'with-mysql'
end

class Zabbix < Formula
  homepage 'http://www.zabbix.com/'
  url 'http://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.0.3/zabbix-2.0.3.tar.gz'
  sha1 'be8902444890db9fb2c4795e62073ce7eea32d96'

  option 'with-mysql', 'Use MySQL library instead PostgreSQL.'

  depends_on (mysql? ? :mysql : :postgresql)
  depends_on 'fping'
  depends_on 'libssh2'

  def brewed_or_shipped(db_config)
    brewed_db_config = "#{HOMEBREW_PREFIX}/bin/#{db_config}"
    (File.exists?(brewed_db_config) && brewed_db_config) || which(db_config)
  end

  def install
    db_adapter = if mysql?
      "--with-mysql=#{brewed_or_shipped('mysql_config')}"
    else
      "--with-postgresql=#{brewed_or_shipped('pg_config')}"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-server",
                          "--enable-proxy",
                          "--enable-agent",
                          "#{db_adapter}",
                          "--enable-ipv6",
                          "--with-net-snmp",
                          "--with-libcurl",
                          "--with-ssh2"

    system "make install"
    (share/'zabbix').install 'frontends/php',
      "database/#{mysql? ? :mysql : :postgresql}"
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
