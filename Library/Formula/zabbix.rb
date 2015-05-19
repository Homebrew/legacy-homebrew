class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "http://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.4.4/zabbix-2.4.4.tar.gz"
  sha256 "e9f31b96104681b050fd27b4a669736dea9c5d4efc8444effb2bff1eab6cc34c"

  bottle do
    sha256 "e272ac2b88acd2d65dcc471c350177104c7a8c0e8c4139531bcb1c5b48074ac5" => :yosemite
    sha256 "46263a6fdf284327bdb8d211ecd60a0374469c23371cd281ec07863743fbce23" => :mavericks
    sha256 "d55dfd1d6a784ca564ffd20ce3969f9d1b89715f65317b7449c9d20ecb12571e" => :mountain_lion
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

    unless build.include? "agent-only"
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
      (share/"zabbix").install "frontends/php", "database/#{db}"
    end
  end

  test do
    system "#{sbin}/zabbix_agentd", "--print"
  end
end
