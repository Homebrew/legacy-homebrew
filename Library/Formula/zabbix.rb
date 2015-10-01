class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.4.6/zabbix-2.4.6.tar.gz"
  sha256 "0ebc6a3326e506cee18826baf2940e39fca3667650f7187e4aa103bf6f7f613c"

  bottle do
    sha256 "ea0c555731f24f86bc0b2b721a339ae6a265116f7ca88a572c64b5ee0e70f3cd" => :yosemite
    sha256 "c6d0238be50628da5cd0b201bac7c50dfada43f2f4725317f39371a6055623b9" => :mavericks
    sha256 "bd5661ac3cb78386872bcb22e5bc85dbb5858be9cbc0cf0ac9ae077e2d30da55" => :mountain_lion
  end

  option "with-mysql", "Use Zabbix Server with MySQL library instead PostgreSQL."
  option "without-server-proxy", "Install only the Zabbix Agent without Server and Proxy."
  option "with-foreground-mode-patch", "Install Zabbix with foreground patch https://support.zabbix.com/browse/ZBXNEXT-611"

  deprecated_option "agent-only" => "without-server-proxy"

  if build.with? "server-proxy"
    depends_on :mysql => :optional
    depends_on :postgresql if build.without? "mysql"
    depends_on "fping"
    depends_on "libssh2"
  end

  # To resolve problem with foreground mode with zabbix https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html#//apple_ref/doc/uid/10000172i-SW7-104302
  # https://support.zabbix.com/browse/ZBXNEXT-611
  # Using patch from openSUSE Build Service
  # https://build.opensuse.org/package/show/server:monitoring:zabbix/zabbix24
  if build.with? "foreground-mode-patch"
    patch :p0 do
      url "https://build.opensuse.org/source/server:monitoring:zabbix/zabbix24/zabbix-2.4.6-run_foreground.patch?rev=dcd5879d64aadd123cb868914d56d6e1"
      sha256 "063b0c6a766ff64006b45a8a683e948b26c7c314efbab2ba50875f02522076a7"
    end
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
      (share/"zabbix").install "frontends/php", "database/#{db}"
    end
  end

  test do
    system "#{sbin}/zabbix_agentd", "--print"
  end
end
