require 'formula'

def postgresql?
  build.include? 'with-postgresql'
end

class Zabbix < Formula
  homepage 'http://www.zabbix.com/'
  url 'http://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.0.3/zabbix-2.0.3.tar.gz'
  sha1 'be8902444890db9fb2c4795e62073ce7eea32d96'

  option 'with-postgresql', 'Use PostgreSQL library instead of MySQL.'

  depends_on (postgresql? ? :postgresql : :mysql)
  depends_on 'fping'
  depends_on 'libssh2'

  def which_or_brewed(binary)
    which(binary) || "#{HOMEBREW_PREFIX}/bin/#{binary}"
  end

  def install
    db_adapter = if postgresql?
      "--with-postgresql=#{which_or_brewed('pg_config')}"
    else
      "--with-mysql=#{which_or_brewed('mysql_config')}"
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
      "database/#{postgresql? ? :postgresql : :mysql}"
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
