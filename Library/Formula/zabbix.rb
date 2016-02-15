class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.4.7/zabbix-2.4.7.tar.gz"
  sha256 "d2c47b8f5b9b91f18010d54c45de55845d979014a8b3fe4bef64e0b08f8b00da"

  bottle do
    sha256 "3f8bd78be75c9ebaf2cf53143172786989f73182abb869ab6999272d2c03f3b3" => :el_capitan
    sha256 "3b5635b83615773218c4e4ac857ae85839a206ac92fcac956b05427492e73bba" => :yosemite
    sha256 "3ff8418c5d5d9c9d6254902f238485cdff00b7c3a4afc8fbbbfafbd745950701" => :mavericks
  end

  option "with-mysql", "Use Zabbix Server with MySQL library instead PostgreSQL."
  option "without-server-proxy", "Install only the Zabbix Agent without Server and Proxy."

  deprecated_option "agent-only" => "without-server-proxy"

  if build.with? "server-proxy"
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
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-agent
      --with-iconv=#{MacOS.sdk_path}/usr
    ]

    if build.with? "server-proxy"
      args += %W[
        --enable-server
        --enable-proxy
        --enable-ipv6
        --with-net-snmp
        --with-libcurl
        --with-ssh2
      ]

      if build.with? "mysql"
        args << "--with-mysql=#{brewed_or_shipped("mysql_config")}"
      else
        args << "--with-postgresql=#{brewed_or_shipped("pg_config")}"
      end
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "server-proxy"
      db = build.with?("mysql") ? "mysql" : "postgresql"
      pkgshare.install "frontends/php", "database/#{db}"
    end
  end

  test do
    system "#{sbin}/zabbix_agentd", "--print"
  end
end
