class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"

  stable do
    url "https://www.process-one.net/downloads/ejabberd/15.07/ejabberd-15.07.tgz"
    sha256 "87d5001521cbb779b84bc74879e032e2514d9a651e24c4e40cce0907ab405bd1"

    resource "p1_cache_tab" do
      url "https://github.com/processone/cache_tab.git",
          :revision => "f7ea12b0ba962a3d2f9a406d2954cf7de4e27230"
    end

    resource "p1_tls" do
      url "https://github.com/processone/tls.git",
          :revision => "2e06ed6ae7d48fe469a2c9cb0869e756105a72f0"
    end

    resource "p1_stringprep" do
      url "https://github.com/processone/stringprep.git",
          :revision => "3c640237a3a7831dc39de6a6d329d3a9af25c579"
    end

    resource "p1_xml" do
      url "https://github.com/processone/xml.git",
          :revision => "7ff90b7a06ee842543bcb47564e8f0e3d3119efd"
    end

    resource "esip" do
      url "https://github.com/processone/p1_sip.git",
          :revision => "d662d3fe7f6288b444ea321d854de0bd6d40e022"
    end

    resource "p1_stun" do
      url "https://github.com/processone/stun.git",
          :revision => "61d90fd9e11fbacb128ebf5cc227d75f6b7e1933"
    end

    resource "p1_yaml" do
      url "https://github.com/processone/p1_yaml.git",
          :revision => "e1f081e1bbf34c35fc60c1b988d62a07fbead3e8"
    end

    resource "p1_utils" do
      url "https://github.com/processone/p1_utils.git",
          :revision => "1bf99f9c8daed3b03f76e2714ca102c520c88b26"
    end

    resource "jiffy" do
      url "https://github.com/davisp/jiffy.git",
          :revision => "e008c0c3fffb4f509c5ae6b73b960663d778f231"
    end

    resource "p1_mysql" do
      url "https://github.com/processone/mysql.git",
          :revision => "d568bbe317c4e86ee58a603c46a98809c1279013"
    end

    resource "p1_pgsql" do
      url "https://github.com/processone/pgsql.git",
          :revision => "e72c03c60bfcb56bbb5d259342021d9cb3581dac"
    end

    resource "sqlite" do
      url "https://github.com/alexeyr/erlang-sqlite3.git",
          :revision => "8350dc603804c503f99c92bfd2eab1dd6885758e"
    end

    resource "p1_pam" do
      url "https://github.com/processone/epam.git",
          :revision => "d3ce290b7da75d780a03e86e7a8198a80e9826a6"
    end

    resource "p1_zlib" do
      url "https://github.com/processone/zlib.git",
          :revision => "e3d4222b7aae616d7ef2e7e2fa0bbf451516c602"
    end

    resource "riakc" do
      url "https://github.com/basho/riak-erlang-client.git",
          :tag => "1.4.2",
          :revision => "8d33c020f4ca392200b2d0d973c77dd48164b263"
    end

    resource "rebar_elixir_plugin" do
      url "https://github.com/yrashk/rebar_elixir_plugin.git",
          :revision => "7058379b7c7e017555647f6b9cecfd87cd50f884"
    end

    resource "elixir" do
      url "https://github.com/elixir-lang/elixir.git",
          :revisison => "1d9548fd285d243721b7eba71912bde2ffd1f6c3"
    end

    resource "p1_iconv" do
      url "https://github.com/processone/eiconv.git",
          :revision => "8b7542b1aaf0a851f335e464956956985af6d9a2"
    end

    resource "lager" do
      url "https://github.com/basho/lager.git",
          :revision => "26540665e640872718d3dd9c35f2addf1279114b"
    end

    resource "p1_logger" do
      url "https://github.com/processone/p1_logger.git",
          :revision => "3e19507fd5606a73694917158767ecb3f5704e3f"
    end

    resource "meck" do
      url "https://github.com/eproxus/meck.git",
          :revision => "fc362e037f424250130bca32d6bf701f2f49dc75"
    end

    resource "eredis" do
      url "https://github.com/wooga/eredis.git",
          :revision => "770f828918db710d0c0958c6df63e90a4d341ed7"
    end
  end

  bottle do
    revision 2
    sha256 "196a2408b3ffda1d3f3c50e2056d55520599b047150ff0e4c0d63dd6375d69a5" => :el_capitan
    sha256 "613df8f7d8462ab98274a11df53188e6f4d3eaf5d2a5a124d3b6ee09b932fc2f" => :yosemite
    sha256 "edd506722dea5e792e0d6b35c56a83a95bbe9f2ecef92cfe01c6c15304293e64" => :mavericks
  end

  head do
    url "https://github.com/processone/ejabberd.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build

    resource "cache_tab" do
      url "https://github.com/processone/cache_tab.git",
        :tag => "1.0.1", :revision => "26caea06c72c2117ca54d04beedb5b49a45af1a8"
    end

    resource "p1_tls" do
      url "https://github.com/processone/tls.git"
    end

    resource "p1_stringprep" do
      url "https://github.com/processone/stringprep.git"
    end

    resource "p1_xml" do
      url "https://github.com/processone/xml.git"
    end

    resource "esip" do
      url "https://github.com/processone/p1_sip.git"
    end

    resource "p1_stun" do
      url "https://github.com/processone/stun.git"
    end

    resource "p1_yaml" do
      url "https://github.com/processone/p1_yaml.git"
    end

    resource "p1_utils" do
      url "https://github.com/processone/p1_utils.git"
    end

    resource "jiffy" do
      url "https://github.com/davisp/jiffy.git"
    end

    resource "p1_mysql" do
      url "https://github.com/processone/mysql.git"
    end

    resource "p1_pgsql" do
      url "https://github.com/processone/pgsql.git"
    end

    resource "sqlite" do
      url "https://github.com/alexeyr/erlang-sqlite3.git"
    end

    resource "p1_pam" do
      url "https://github.com/processone/epam.git"
    end

    resource "p1_zlib" do
      url "https://github.com/processone/zlib.git"
    end

    resource "riakc" do
      url "https://github.com/basho/riak-erlang-client.git"
    end

    resource "rebar_elixir_plugin" do
      url "https://github.com/processone/rebar_elixir_plugin.git"
    end

    resource "elixir" do
      url "https://github.com/elixir-lang/elixir.git"
    end

    resource "p1_iconv" do
      url "https://github.com/processone/eiconv.git"
    end

    resource "lager" do
      url "https://github.com/basho/lager.git"
    end

    resource "p1_logger" do
      url "https://github.com/processone/p1_logger.git"
    end

    resource "meck" do
      url "https://github.com/eproxus/meck.git"
    end

    resource "eredis" do
      url "https://github.com/wooga/eredis.git"
    end

    resource "oauth2" do
      url "https://github.com/prefiks/oauth2.git"
    end

    resource "xmlrpc" do
      url "https://github.com/rds13/xmlrpc.git"
    end
  end

  option "32-bit"

  depends_on "openssl"
  depends_on "erlang"
  depends_on "libyaml"
  # for CAPTCHA challenges
  depends_on "imagemagick" => :optional

  def install
    ENV["TARGET_DIR"] = ENV["DESTDIR"] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV["MAN_DIR"] = man
    ENV["SBIN_DIR"] = sbin

    if build.build_32_bit?
      ENV.append %w[CFLAGS LDFLAGS], "-arch #{Hardware::CPU.arch_32_bit}"
    end

    deps_file = build.head? ? "rebar.config" : "rebar.config.script"

    resources.each do |r|
      r.fetch
      r.url =~ %r{github\.com/([^/]+)/(.+?)\.git$}
      user = $1
      repo = $2

      inreplace deps_file,
        # match https://github.com, git://github.com, and git@github
        %r{(?:https://|git(?:://|@))github\.com[:/]#{user}/#{repo}(?:\.git)?},
        r.cached_download
    end

    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}",
            "--enable-pgsql",
            "--enable-mysql",
            "--enable-odbc",
            "--enable-pam",
           ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"

    (etc/"ejabberd").mkpath
    (var/"lib/ejabberd").mkpath
    (var/"spool/ejabberd").mkpath
  end

  def caveats; <<-EOS.undent
    If you face nodedown problems, concat your machine name to:
      /private/etc/hosts
    after 'localhost'.
    EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/ejabberdctl start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>EnvironmentVariables</key>
      <dict>
        <key>HOME</key>
        <string>#{var}/lib/ejabberd</string>
      </dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/ejabberdctl</string>
        <string>start</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}/lib/ejabberd</string>
    </dict>
    </plist>
    EOS
  end
end
