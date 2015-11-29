class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://www.process-one.net/downloads/ejabberd/15.07/ejabberd-15.07.tgz"
  sha256 "87d5001521cbb779b84bc74879e032e2514d9a651e24c4e40cce0907ab405bd1"

  bottle do
    revision 1
    sha256 "aa2bb08b3b8879082536d9eef3562f85c15ebe858733066a38abf1d7f41b5294" => :el_capitan
    sha256 "ea72a4a4677aea8d93cea43e656f7ebdd7289bd5a5c54873602c26e911f09a1f" => :yosemite
    sha256 "7ef72216ebc90e504af032e73e3cffb0d7f3477abdf2dcbf730029a2a83bc5fc" => :mavericks
  end

  head do
    url "https://github.com/processone/ejabberd.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build

    resource "oauth2" do
      url "https://github.com/prefiks/oauth2",
          :using => :git,
          :revision => "e6da9912e5d8f658e7e868f41a102d085bdbef59"
    end

    resource "xmlrpc" do
      url "https://github.com/rds13/xmlrpc",
          :using => :git,
          :revision => "42e6e96a0fe7106830274feed915125feb1056f3"
    end
  end

  option "32-bit"

  depends_on "openssl"
  depends_on "erlang"
  depends_on "libyaml"
  # for CAPTCHA challenges
  depends_on "imagemagick" => :optional

  resource "p1_cache_tab" do
    url "https://github.com/processone/cache_tab",
        :using => :git,
        :revision => "f7ea12b0ba962a3d2f9a406d2954cf7de4e27230"
  end

  resource "p1_tls" do
    url "https://github.com/processone/tls",
        :using => :git,
        :revision => "e56321afd974e9da33da913cd31beebc8e73e75f"
  end

  resource "p1_stringprep" do
    url "https://github.com/processone/stringprep",
        :using => :git,
        :revision => "941b454684d230caf514ee2877085dcf92722a97"
  end

  resource "p1_xml" do
    url "https://github.com/processone/xml",
        :using => :git,
        :revision => "8d477a2cb8846a739fefa0714cc6812aed15c6e1"
  end

  resource "esip" do
    url "https://github.com/processone/p1_sip",
        :using => :git,
        :revision => "d662d3fe7f6288b444ea321d854de0bd6d40e022"
  end

  resource "p1_stun" do
    url "https://github.com/processone/stun",
        :using => :git,
        :revision => "061bdae484268cbf0457ad4797e74b8516df3ad1"
  end

  resource "p1_yaml" do
    url "https://github.com/processone/p1_yaml",
        :using => :git,
        :revision => "79f756ba73a235c4d3836ec07b5f7f2b55f49638"
  end

  resource "p1_utils" do
    url "https://github.com/processone/p1_utils",
        :using => :git,
        :revision => "0799907b75d1c23fc279a184ef4742a26d4242c5"
  end

  resource "jiffy" do
    url "https://github.com/davisp/jiffy",
        :using => :git,
        :revision => "cfc61a2e952dc3182e0f9b1473467563699992e2"
  end

  resource "p1_mysql" do
    url "https://github.com/processone/mysql",
        :using => :git,
        :revision => "dfa87da95f8fdb92e270741c2a53f796b682f918"
  end

  resource "p1_pgsql" do
    url "https://github.com/processone/pgsql",
        :using => :git,
        :revision => "e72c03c60bfcb56bbb5d259342021d9cb3581dac"
  end

  resource "sqlite" do
    url "https://github.com/alexeyr/erlang-sqlite3",
        :using => :git,
        :revision => "8350dc603804c503f99c92bfd2eab1dd6885758e"
  end

  resource "p1_pam" do
    url "https://github.com/processone/epam",
        :using => :git,
        :revision => "d3ce290b7da75d780a03e86e7a8198a80e9826a6"
  end

  resource "p1_zlib" do
    url "https://github.com/processone/zlib",
        :using => :git,
        :revision => "e3d4222b7aae616d7ef2e7e2fa0bbf451516c602"
  end

  resource "riakc" do
    url "https://github.com/basho/riak-erlang-client",
        :using => :git,
        :revision => "527722d12d0433b837cdb92a60900c2cb5df8942"
  end

  resource "rebar_elixir_plugin" do
    url "https://github.com/yrashk/rebar_elixir_plugin",
        :using => :git,
        :revision => "7058379b7c7e017555647f6b9cecfd87cd50f884"
  end

  resource "elixir" do
    url "https://github.com/elixir-lang/elixir",
        :using => :git,
        :revisison => "805ee01b5f432625bfb74dd95ebcd70a57d7ea2f"
  end

  resource "p1_iconv" do
    url "https://github.com/processone/eiconv",
        :using => :git,
        :revision => "8b7542b1aaf0a851f335e464956956985af6d9a2"
  end

  resource "lager" do
    url "https://github.com/basho/lager",
        :using => :git,
        :revision => "1265b62df5ad9c874f3f3518d7b7f5eb087701fc"
  end

  resource "p1_logger" do
    url "https://github.com/processone/p1_logger",
        :using => :git,
        :revision => "3e19507fd5606a73694917158767ecb3f5704e3f"
  end

  resource "meck" do
    url "https://github.com/eproxus/meck",
        :using => :git,
        :revision => "be12fdf0522162f801093ec1d52ed2e99dc4c025"
  end

  resource "eredis" do
    url "https://github.com/wooga/eredis",
        :using => :git,
        :revision => "bf12ecb30253c84a2331f4f0d93fd68856fcb9f4"
  end

  def install
    ENV["TARGET_DIR"] = ENV["DESTDIR"] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV["MAN_DIR"] = man
    ENV["SBIN_DIR"] = sbin

    if build.build_32_bit?
      ENV.append %w[CFLAGS LDFLAGS], "-arch #{Hardware::CPU.arch_32_bit}"
    end

    resources.each do |r|
      r.fetch
      if r.name == "oauth2" || r.name == "xmlrpc"
        inreplace "rebar.config.script", "#{r.url}.git", r.cached_download
      else
        inreplace "rebar.config.script", r.url, r.cached_download
      end
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
