class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.org/en/latest/"
  url "https://projects.unbit.it/downloads/uwsgi-2.0.11.2.tar.gz"
  sha256 "0b889b0b4d2dd3f6625df28cb0b86ec44a68d074ede2d0dfad0b91e88914885c"
  revision 1

  head "https://github.com/unbit/uwsgi.git"

  bottle do
    sha256 "558709cfcdbb5d9a552753276e35ddd223315cc42fdb2144eea1c8e1af523257" => :el_capitan
    sha256 "5007d96dd0c8eb687a0137460042a5178943b754880fc6ded9dc33608bd0d1f2" => :yosemite
    sha256 "9cc48b037ae97dab7c026a0c6af3021f984de4446d0e8ac089f38c62a06a97ff" => :mavericks
  end

  option "with-java", "Compile with Java support"
  option "with-php", "Compile with PHP support (PHP must be built for embedding)"
  option "with-ruby", "Compile with Ruby support"

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "openssl"
  depends_on :python if MacOS.version <= :snow_leopard

  depends_on "geoip" => :optional
  depends_on "gloox" => :optional
  depends_on "go" => [:build, :optional]
  depends_on "jansson" => :optional
  depends_on "libffi" => :optional
  depends_on "libxslt" => :optional
  depends_on "libyaml" => :optional
  depends_on "lua51" => :optional
  depends_on "mongodb" => :optional
  depends_on "mongrel2" => :optional
  depends_on "mono" => :optional
  depends_on "nagios" => :optional
  depends_on "postgresql" => :optional
  depends_on "pypy" => :optional
  depends_on "python" => :optional
  depends_on "python3" => :optional
  depends_on "rrdtool" => :optional
  depends_on "rsyslog" => :optional
  depends_on "tcc" => :optional
  depends_on "v8" => :optional
  depends_on "zeromq" => :optional
  depends_on "yajl" if build.without? "jansson"

  def install
    ENV.append %w[CFLAGS LDFLAGS], "-arch #{MacOS.preferred_arch}"
    openssl = Formula["openssl"]
    ENV.prepend "CFLAGS", "-I#{openssl.opt_include}"
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"

    json = build.with?("jansson") ? "jansson" : "yajl"
    yaml = build.with?("libyaml") ? "libyaml" : "embedded"

    # Fix build on case-sensitive filesystems
    # https://github.com/Homebrew/homebrew/issues/45560
    # https://github.com/unbit/uwsgi/pull/1128
    inreplace "plugins/alarm_speech/uwsgiplugin.py", "'-framework appkit'", "'-framework AppKit'"

    (buildpath/"buildconf/brew.ini").write <<-EOS.undent
      [uwsgi]
      ssl = true
      json = #{json}
      yaml = #{yaml}
      inherit = base
      plugin_dir = #{libexec}/uwsgi
      embedded_plugins = null
    EOS

    system "python", "uwsgiconfig.py", "--verbose", "--build", "brew"

    plugins = ["airbrake", "alarm_curl", "alarm_speech", "asyncio", "cache",
               "carbon", "cgi", "cheaper_backlog2", "cheaper_busyness",
               "corerouter", "curl_cron", "cplusplus", "dumbloop", "dummy",
               "echo", "emperor_amqp", "fastrouter", "forkptyrouter", "gevent",
               "http", "logcrypto", "logfile", "ldap", "logpipe", "logsocket",
               "msgpack", "notfound", "pam", "ping", "psgi", "pty", "rawrouter",
               "router_basicauth", "router_cache", "router_expires",
               "router_hash", "router_http", "router_memcached",
               "router_metrics", "router_radius", "router_redirect",
               "router_redis", "router_rewrite", "router_static",
               "router_uwsgi", "router_xmldir", "rpc", "signal", "spooler",
               "sqlite3", "sslrouter", "stats_pusher_file",
               "stats_pusher_socket", "symcall", "syslog",
               "transformation_chunked", "transformation_gzip",
               "transformation_offload", "transformation_tofile",
               "transformation_toupper", "ugreen", "webdav", "zergpool"]

    plugins << "alarm_xmpp" if build.with? "gloox"
    plugins << "emperor_mongodb" if build.with? "mongodb"
    plugins << "emperor_pg" if build.with? "postgresql"
    plugins << "ffi" if build.with? "libffi"
    plugins << "fiber" if build.with? "ruby"
    plugins << "gccgo" if build.with? "go"
    plugins << "geoip" if build.with? "geoip"
    plugins << "jvm" if build.with? "java"
    plugins << "jwsgi" if build.with? "java"
    plugins << "libtcc" if build.with? "tcc"
    plugins << "lua" if build.with? "lua"
    plugins << "mongodb" if build.with? "mongodb"
    plugins << "mongodblog" if build.with? "mongodb"
    plugins << "mongrel2" if build.with? "mongrel2"
    plugins << "mono" if build.with? "mono"
    plugins << "nagios" if build.with? "nagios"
    plugins << "pypy" if build.with? "pypy"
    plugins << "php" if build.with? "php"
    plugins << "rack" if build.with? "ruby"
    plugins << "rbthreads" if build.with? "ruby"
    plugins << "ring" if build.with? "java"
    plugins << "rrdtool" if build.with? "rrdtool"
    plugins << "rsyslog" if build.with? "rsyslog"
    plugins << "servlet" if build.with? "java"
    plugins << "stats_pusher_mongodb" if build.with? "mongodb"
    plugins << "v8" if build.with? "v8"
    plugins << "xslt" if build.with? "libxslt"

    (libexec/"uwsgi").mkpath
    plugins.each do |plugin|
      system "python", "uwsgiconfig.py", "--verbose", "--plugin", "plugins/#{plugin}", "brew"
    end

    python_versions = ["python", "python2"]
    python_versions << "python3" if build.with? "python3"
    python_versions.each do |v|
      system "python", "uwsgiconfig.py", "--verbose", "--plugin", "plugins/python", "brew", v
    end

    bin.install "uwsgi"
  end

  plist_options :manual => "uwsgi"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/uwsgi</string>
            <string>--uid</string>
            <string>_www</string>
            <string>--gid</string>
            <string>_www</string>
            <string>--master</string>
            <string>--die-on-term</string>
            <string>--autoload</string>
            <string>--logto</string>
            <string>#{HOMEBREW_PREFIX}/var/log/uwsgi.log</string>
            <string>--emperor</string>
            <string>#{HOMEBREW_PREFIX}/etc/uwsgi/apps-enabled</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"helloworld.py").write <<-EOS.undent
      def application(env, start_response):
        start_response('200 OK', [('Content-Type','text/html')])
        return [b"Hello World"]
    EOS

    pid = fork do
      exec "#{bin}/uwsgi --http-socket 127.0.0.1:8080 --protocol=http --plugin python -w helloworld"
    end
    sleep 2

    begin
      assert_match "Hello World", shell_output("curl localhost:8080")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
