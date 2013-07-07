require 'formula'

class Zabbix < Formula
  homepage 'http://www.zabbix.com/'
  url 'http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/2.0.6/zabbix-2.0.6.tar.gz'
  sha1 '75a747ddcfa4bcd5792f69dc8d7de9c5839b8595'

  option 'with-mysql', 'Use Zabbix Server with MySQL library instead PostgreSQL.'
  option 'agent-only', 'Install only the Zabbix Agent without Server and Proxy.'

  unless build.include?('agent-only')
    depends_on (build.include?('with-mysql') ? :mysql : :postgresql)
    depends_on 'fping'
    depends_on 'libssh2'
  end

  def brewed_or_shipped(db_config)
    brewed_db_config = "#{HOMEBREW_PREFIX}/bin/#{db_config}"
    (File.exists?(brewed_db_config) && brewed_db_config) || which(db_config)
  end

  def install
    args = %W{
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-agent
    }

    unless build.include?('agent-only')
      db_adapter = if build.include?('with-mysql')
        "--with-mysql=#{brewed_or_shipped('mysql_config')}"
      else
        "--with-postgresql=#{brewed_or_shipped('pg_config')}"
      end
      args += %W{
        --enable-server
        --enable-proxy
        #{db_adapter}
        --enable-ipv6
        --with-net-snmp
        --with-libcurl
        --with-ssh2
      }
    end

    system "./configure", *args
    system "make install"

    unless build.include?('agent-only')
      (share/'zabbix').install 'frontends/php',
        "database/#{build.include?('with-mysql') ? :mysql : :postgresql}"
    end
  end

  def test
    system "#{sbin}/zabbix_agentd", "--print"
  end
end
