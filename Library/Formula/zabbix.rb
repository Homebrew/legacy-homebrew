require "formula"

class Zabbix < Formula
  homepage "http://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.4.2/zabbix-2.4.2.tar.gz"
  sha1 "627ed5196b81a1f4e36690695dfbcaa1803890e3"

  bottle do
    sha1 "5e335b2e0fe5ccae9dbc375ca15a6c60b1560f1d" => :yosemite
    sha1 "ff74e25cf747013e6f8f98685f51387758c85fd1" => :mavericks
    sha1 "1bc4d521656fb5439330143352dcd7944dce88fb" => :mountain_lion
  end

  option "with-mysql", "Use Zabbix Server with MySQL library instead PostgreSQL."
  option "agent-only", "Install only the Zabbix Agent without Server and Proxy."

  unless build.include? "agent-only"
    depends_on :mysql => :optional
    depends_on :postgresql if build.without? "mysql"
    depends_on "fping"
    depends_on "libssh2"
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
      --with-iconv=#{MacOS.sdk_path}/usr
    }

    unless build.include? "agent-only"
      args += %W{
        --enable-server
        --enable-proxy
        --enable-ipv6
        --with-net-snmp
        --with-libcurl
        --with-ssh2
      }
      if build.with? "mysql"
        args << "--with-mysql=#{brewed_or_shipped('mysql_config')}"
      else
        args << "--with-postgresql=#{brewed_or_shipped('pg_config')}"
      end
    end

    system "./configure", *args
    system "make install"

    unless build.include? "agent-only"
      db = build.with?("mysql") ? "mysql" : "postgresql"
      (share/"zabbix").install "frontends/php", "database/#{db}"
    end
  end

  test do
    system "#{sbin}/zabbix_agentd", "--print"
  end
end
