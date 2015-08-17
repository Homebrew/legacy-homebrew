class Lighttpd < Formula
  desc "Small memory footprint, flexible web-server"
  homepage "http://www.lighttpd.net/"
  url "http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.36.tar.xz"
  sha256 "897ab6b1cc7bd51671f8af759e7846245fbbca0685c30017e93a5882a9ac1a53"

  bottle do
    revision 1
    sha256 "7a88d41abb5e7ade23e1cec1baa71c38a045e162f160303f07dd7d854ca7c8d3" => :yosemite
    sha256 "48404aef3bd458b5c63a1162b579466b8d77264287b5721f3abe63339c17d227" => :mavericks
    sha256 "d4b861b7b36a0f984cafcc14703f2c4a49be23be4ff24f41310d65f95df25f00" => :mountain_lion
  end

  option "with-lua51", "Include Lua scripting support for mod_magnet"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre"
  depends_on "openssl"
  depends_on "lua51" => :optional
  depends_on "libev" => :optional

  # default max. file descriptors; this option will be ignored if the server is not started as root
  MAX_FDS = 512

  def config_path
    etc+"lighttpd"
  end

  def log_path
    var+"log/lighttpd"
  end

  def www_path
    var+"www"
  end

  def run_path
    var+"lighttpd"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sbindir=#{bin}
      --with-openssl
      --with-ldap
      --with-zlib
      --with-bzip2
      --with-attr
    ]

    args << "--with-lua" if build.with? "lua51"
    args << "--with-libev" if build.with? "libev"

    # fixed upstream, should be in next release: http://redmine.lighttpd.net/issues/2517
    inreplace "src/Makefile.am", "$(LDAP_LIB)", "$(SSL_LIB) $(LDAP_LIB)"

    # autogen must be run, otherwise prebuilt configure may complain
    # about a version mismatch between included automake and Homebrew's
    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"

    unless File.exist? config_path
      config_path.install "doc/config/lighttpd.conf", "doc/config/modules.conf"
      (config_path/"conf.d/").install Dir["doc/config/conf.d/*.conf"]
      inreplace config_path+"lighttpd.conf" do |s|
        s.sub!(/^var\.log_root\s*=\s*".+"$/, "var.log_root    = \"#{log_path}\"")
        s.sub!(/^var\.server_root\s*=\s*".+"$/, "var.server_root = \"#{www_path}\"")
        s.sub!(/^var\.state_dir\s*=\s*".+"$/, "var.state_dir   = \"#{run_path}\"")
        s.sub!(/^var\.home_dir\s*=\s*".+"$/, "var.home_dir    = \"#{run_path}\"")
        s.sub!(/^var\.conf_dir\s*=\s*".+"$/, "var.conf_dir    = \"#{config_path}\"")
        s.sub!(/^server\.port\s*=\s*80$/, "server.port = 8080")
        s.sub!(%r{^server\.document-root\s*=\s*server_root \+ "\/htdocs"$}, "server.document-root = server_root")

        # get rid of "warning: please use server.use-ipv6 only for hostnames, not
        # without server.bind / empty address; your config will break if the kernel
        # default for IPV6_V6ONLY changes"
        s.sub!(/^server.use-ipv6\s*=\s*"enable"$/, 'server.use-ipv6 = "disable"')

        s.sub!(/^server\.username\s*=\s*".+"$/, 'server.username  = "_www"')
        s.sub!(/^server\.groupname\s*=\s*".+"$/, 'server.groupname = "_www"')
        s.sub!(/^server\.event-handler\s*=\s*"linux-sysepoll"$/, 'server.event-handler = "select"')
        s.sub!(/^server\.network-backend\s*=\s*"linux-sendfile"$/, 'server.network-backend = "writev"')

        # "max-connections == max-fds/2",
        # http://redmine.lighttpd.net/projects/1/wiki/Server_max-connectionsDetails
        s.sub!(/^server\.max-connections = .+$/, "server.max-connections = " + (MAX_FDS / 2).to_s)
      end
    end

    log_path.mkpath
    (www_path/"htdocs").mkpath
    run_path.mkpath
  end

  def caveats; <<-EOS.undent
    Docroot is: #{www_path}

    The default port has been set in #{config_path}lighttpd.conf to 8080 so that
    lighttpd can run without sudo.
    EOS
  end

  test do
    system "#{bin}/lighttpd", "-t", "-f", config_path+"lighttpd.conf"
  end

  plist_options :manual => "lighttpd -f #{HOMEBREW_PREFIX}/etc/lighttpd/lighttpd.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/lighttpd</string>
        <string>-D</string>
        <string>-f</string>
        <string>#{config_path}/lighttpd.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{log_path}/output.log</string>
      <key>StandardOutPath</key>
      <string>#{log_path}/output.log</string>
      <key>HardResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>#{MAX_FDS}</integer>
      </dict>
      <key>SoftResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>#{MAX_FDS}</integer>
      </dict>
    </dict>
    </plist>
    EOS
  end
end
