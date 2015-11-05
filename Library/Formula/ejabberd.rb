class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://www.process-one.net/downloads/ejabberd/15.07/ejabberd-15.07.tgz"
  sha256 "87d5001521cbb779b84bc74879e032e2514d9a651e24c4e40cce0907ab405bd1"

  head "https://github.com/processone/ejabberd.git"

  bottle do
    sha256 "4001c8bf43972697862ead67f944177c6a6b771c96a4d6de75f68694ed7aa620" => :el_capitan
    sha256 "592a3412890d52da9d8a9f43a288dca8eab233dcd0c59d17d4bd8f89b7b4567b" => :yosemite
    sha256 "17b97c88ea724e8816c445a944ad71a9be141cf9afe8e4f168dd271ea2bd8448" => :mavericks
    sha256 "f53c7307acaee6aafa813785ede998900c0c32db2d0f28dfb5dd51c45b6f5366" => :mountain_lion
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

    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}",
            "--enable-pgsql",
            "--enable-mysql",
            "--enable-odbc",
            "--enable-pam",
           ]

    system "./configure", *args
    system "make"
    system "make", "install"

    (etc+"ejabberd").mkpath
    (var+"lib/ejabberd").mkpath
    (var+"spool/ejabberd").mkpath
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
