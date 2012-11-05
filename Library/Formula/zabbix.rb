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


class PostgresqlInstalled < Requirement
  def message; <<-EOS.undent
    PostgreSQL is required to install.

    You can install this with:
      brew install postgresql

    Or you can use an official installer from:
      http://www.postgresql.org/
    EOS
  end

  def satisfied?
    which 'pg_config'
  end

  def fatal?
    true
  end
end


class Zabbix < Formula
  homepage 'http://www.zabbix.com/'
  url 'http://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.0.3/zabbix-2.0.3.tar.gz'
  sha1 'be8902444890db9fb2c4795e62073ce7eea32d96'

  option 'with-postgresql', 'Use PostgreSQL library instead of MySQL.'

  depends_on (build.include?('with-postgresql') ? PostgresqlInstalled.new : MySqlInstalled.new)
  depends_on 'fping'
  depends_on 'libssh2'

  def which_or_brewed(binary)
    which(binary) || "#{HOMEBREW_PREFIX}/bin/#{binary}"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-server",
                          "--enable-proxy",
                          "--enable-agent",
                          (build.include?('with-postgresql') ? "--with-postgresql=#{which_or_brewed('pg_config')}" : "--with-mysql=#{which_or_brewed('mysql_config')}"),
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
