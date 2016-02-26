class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"

  stable do
    url "https://collectd.org/files/collectd-5.5.1.tar.bz2"
    mirror "http://pkgs.fedoraproject.org/repo/pkgs/collectd/collectd-5.5.1.tar.bz2/fd24b947cef9351ce3e2d6d2a0762e18/collectd-5.5.1.tar.bz2"
    sha256 "f9c5d526e1f0429a7db1ccd90bdf9e23923a2fd43b7285cfda8f0341e5c0bc3f"
  end

  bottle do
    sha256 "2d0ea64e88be3e27d28e8419c88eda50180d82b4070c4a819bfa54fecad3030d" => :el_capitan
    sha256 "40e0865b2e465387ead14eedb6ae5f639a60a00e0aaa36380ef9f23966772d4a" => :yosemite
    sha256 "2626142f0ec513f28faac27c1c81af720a6da37980b994d918fef7ed08da3b16" => :mavericks
  end

  head do
    url "https://github.com/collectd/collectd.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  option "with-debug", "Enable debug support"
  option "with-hiredis", "Enable Redis and write_redis plugins"
  option "with-java", "Enable Java support"
  option "with-libvirt", "Enable Libvirt plugin"
  option "with-mysql", "Enable MySQL plugin"
  option "with-net-snmp", "Enable SNMP plugin"
  option "with-postgresql", "Enable PostgreSQL plugin"
  option "with-protobuf-c", "Enable write_riemann plugin"
  option "with-rrdtool", "Enable rrdtool and rrdcached plugins"
  option "with-varnish", "Enable Varnish plugin"
  option "with-yajl", "Enable Curl JSON and log_logstash plugins"

  deprecated_option "java" => "with-java"
  deprecated_option "debug" => "with-debug"

  depends_on "hiredis" => :optional
  depends_on "libvirt" => :optional
  depends_on "mysql" => :optional
  depends_on "openssl"
  depends_on "pkg-config" => :build
  depends_on "postgresql" => :optional
  depends_on "protobuf-c" => :optional
  depends_on "net-snmp" => :optional
  depends_on "rrdtool" => :optional
  depends_on "varnish" => :optional
  depends_on "yajl" => :optional
  depends_on :java => :optional

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      Clang interacts poorly with the collectd-bundled libltdl,
      causing configure to fail.
    EOS
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --disable-all-plugins
      --enable-aggregation
      --enable-apache
      --enable-apple_sensors
      --enable-battery
      --enable-cpu
      --enable-csv
      --enable-curl
      --enable-curl_xml
      --enable-df
      --enable-disk
      --enable-exec
      --enable-filecount
      --enable-interface
      --enable-load
      --enable-logfile
      --enable-match_empty_counter
      --enable-match_hashed
      --enable-match_regex
      --enable-match_timediff
      --enable-match_value
      --enable-memcached
      --enable-memory
      --enable-network
      --enable-nginx
      --enable-ntpd
      --enable-openvpn
      --enable-perl
      --enable-powerdns
      --enable-processes
      --enable-statsd
      --enable-swap
      --enable-syslog
      --enable-table
      --enable-tail_csv
      --enable-tail
      --enable-target_notification
      --enable-target_replace
      --enable-target_scale
      --enable-target_set
      --enable-target_v5upgrade
      --enable-tcpconns
      --enable-threshold
      --enable-unixsock
      --enable-uptime
      --enable-users
      --enable-write_graphite
      --enable-write_http
      --enable-write_log
      --enable-write_sensu
      --enable-write_tsdb
      --enable-zookeeper
    ]

    args << "--disable-embedded-perl" if MacOS.version <= :leopard
    args << "--enable-debug" if build.with? "debug"
    args << "--enable-curl_json" if build.with? "yajl"
    args << "--enable-java" if build.with? "java"
    args << "--enable-log_logstash" if build.with? "protobuf-c"
    args << "--enable-mysql" if build.with? "mysql"
    args << "--enable-postgresql" if build.with? "postgresql"
    args << "--enable-redis" if build.with? "hiredis-c"
    args << "--enable-rrdcached" if build.with? "rrdtool"
    args << "--enable-rrdtool" if build.with? "rrdtool"
    args << "--enable-snmp" if build.with? "net-snmp"
    args << "--enable-varnish" if build.with? "varnish"
    args << "--enable-virt" if build.with? "libvirt"
    args << "--enable-write_redis" if build.with? "hiredis-c"
    args << "--enable-write_riemann" if build.with? "protobuf-c"

    system "./build.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/collectd</string>
          <string>-f</string>
          <string>-C</string>
          <string>#{etc}/collectd.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/collectd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/collectd.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    begin
      pid = fork { exec sbin/"collectd", "-f" }
      assert shell_output("nc -u -w 2 127.0.0.1 25826", 0)
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
