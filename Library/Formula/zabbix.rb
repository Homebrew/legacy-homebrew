require 'formula'

class Zabbix < Formula
  homepage 'http://www.zabbix.com/'
  url 'https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.2.3/zabbix-2.2.3.tar.gz'
  sha1 '23a7363e3af1d44cd74f22cdd90d16f7f235b14d'

  option 'with-mysql', 'Use Zabbix Server with MySQL library instead PostgreSQL.'
  option 'agent-only', 'Install only the Zabbix Agent without Server and Proxy.'

  unless build.include? 'agent-only'
    depends_on :mysql => :optional
    depends_on :postgresql if build.without? 'mysql'
    depends_on 'fping'
    depends_on 'libssh2'
  end

  def brewed_or_shipped(db_config)
    brewed_db_config = "#{HOMEBREW_PREFIX}/bin/#{db_config}"
    (File.exist?(brewed_db_config) && brewed_db_config) || which(db_config)
  end

  def install
    args = %W{
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-agent
    }

    unless build.include? 'agent-only'
      args += %W{
        --enable-server
        --enable-proxy
        --enable-ipv6
        --with-net-snmp
        --with-libcurl
        --with-ssh2
      }
      if build.with? 'mysql'
        args << "--with-mysql=#{brewed_or_shipped('mysql_config')}"
      else
        args << "--with-postgresql=#{brewed_or_shipped('pg_config')}"
      end
    end

    system "./configure", *args
    system "make install"

    unless build.include? 'agent-only'
      db = build.with?('mysql') ? 'mysql' : 'postgresql'
      (share/'zabbix').install 'frontends/php', "database/#{db}"
    end
  end

  test do
    system "#{sbin}/zabbix_agentd", "--print"
  end
end
