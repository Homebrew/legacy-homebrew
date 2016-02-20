class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"

  stable do
    url "https://www.process-one.net/downloads/ejabberd/16.01/ejabberd-16.01.tgz"
    sha256 "e2cc479d5870539b2e6756690b227969c88a541d464d1fc6e1cbf7270ad7d681"

    resource "lager" do
      url "https://github.com/basho/lager.git",
          :tag => "3.0.2",
          :revision => "599dda6786a81200e00b3d9b4b36951e052727a3"
    end

    resource "p1_logger" do
      url "https://github.com/processone/p1_logger.git",
          :tag => "1.0.0",
          :revision => "bb8cfb9eca102197bfaaf34ce6c59cb296b7516f"
    end

    resource "p1_utils" do
      url "https://github.com/processone/p1_utils.git",
          :tag => "1.0.2",
          :revision => "e6779f1ee7a0841da08a063930d7ea51c2be4203"
    end

    resource "cache_tab" do
      url "https://github.com/processone/cache_tab.git",
          :tag => "1.0.1",
          :revision => "26caea06c72c2117ca54d04beedb5b49a45af1a8"
    end

    resource "p1_tls" do
      url "https://github.com/processone/tls.git",
          :tag => "1.0.0",
          :revision => "f19e1f701e0a3980ffc70b3917c4aa85e68d8520"
    end

    resource "p1_stringprep" do
      url "https://github.com/processone/stringprep.git",
          :tag => "1.0.0",
          :revision => "7315a75360547cd6458b144a65ede64b44c6193d"
    end

    resource "p1_xml" do
      url "https://github.com/processone/xml.git",
          :tag => "1.1.1",
          :revision => "1190214326c70101db26809b61c2d30133c940b1"
    end

    resource "p1_stun" do
      url "https://github.com/processone/stun.git",
          :tag => "0.9.0",
          :revision => "ab418dfb11bd9b37d6f7501420f32384729fecd7"
    end

    resource "esip" do
      url "https://github.com/processone/p1_sip.git",
          :tag => "1.0.0",
          :revision => "ff3cc9fa2f9ea96f47e6b5b60a04da90889a5626"
    end

    resource "p1_yaml" do
      url "https://github.com/processone/p1_yaml.git",
          :tag => "1.0.0",
          :revision => "753f99c39200705bb7ccb6f38f7f10aeb45c0ea4"
    end

    resource "jiffy" do
      url "https://github.com/davisp/jiffy.git",
          :tag => "0.14.5",
          :revision => "e43ea64ae0d227af5dd003132234cdf4494d781d"
    end

    resource "oauth2" do
      url "https://github.com/kivra/oauth2.git",
          :revision => "8d129fbf8866930b4ffa6dd84e65bd2b32b9acb8"
    end

    resource "xmlrpc" do
      url "https://github.com/rds13/xmlrpc.git",
          :tag => "1.15",
          :revision => "9cd92b219ad97869d9da19ee4ea25ba1a40aea98"
    end

    resource "p1_mysql" do
      url "https://github.com/processone/mysql.git",
          :tag => "1.0.0",
          :revision => "064948ad3c77e582d85cbc09ccd11016ae97de0e"
    end

    resource "p1_pgsql" do
      url "https://github.com/processone/pgsql.git",
          :tag => "1.0.0",
          :revision => "248b6903cad82c748dc7f5be75e014dd8d47a3d1"
    end

    resource "sqlite3" do
      url "https://github.com/alexeyr/erlang-sqlite3.git",
          :revision => "cbc3505f7a131254265d3ef56191b2581b8cc172"
    end

    resource "p1_pam" do
      url "https://github.com/processone/epam.git",
          :tag => "1.0.0",
          :revision => "f0d6588f4733c4d8068af44cf51c966af8bf514a"
    end

    resource "p1_zlib" do
      url "https://github.com/processone/zlib.git",
          :tag => "1.0.0",
          :revision => "e1f928e61553cf85638eaac7d024c8f68ce0ff36"
    end

    resource "hamcrest" do
      url "https://github.com/hyperthunk/hamcrest-erlang.git",
          :revision => "908a24fda4a46776a5135db60ca071e3d783f9f6"
    end

    resource "riakc" do
      url "https://github.com/basho/riak-erlang-client.git",
          :revision => "527722d12d0433b837cdb92a60900c2cb5df8942"
    end

    resource "elixir" do
      url "https://github.com/elixir-lang/elixir.git",
          :tag => "v1.1.0",
          :revision => "f2a9c7016633ca63541a8160c63a53eb7edbccdb"
    end

    resource "rebar_elixir_plugin" do
      url "https://github.com/processone/rebar_elixir_plugin.git",
          :tag => "0.1.0",
          :revision => "10614dfef5d10b7071f7181858149259e50159f6"
    end

    resource "p1_iconv" do
      url "https://github.com/processone/eiconv.git",
          :tag => "0.9.0",
          :revision => "9751f86baa5a60ed1420490793e7514a0757462a"
    end

    resource "meck" do
      url "https://github.com/eproxus/meck.git",
          :tag => "0.8.2",
          :revision => "dde759050eff19a1a80fd854d7375174b191665d"
    end

    resource "eredis" do
      url "https://github.com/wooga/eredis.git",
          :tag => "v1.0.8",
          :revision => "cbc013f516e464706493c01662e5e9dd82d1db01"
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

    deps_file = "rebar.config"

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

  test do
    system "#{sbin}/ejabberdctl", "ping"
  end
end
