class Ejabberd < Formula
  homepage "https://www.ejabberd.im"
  url "https://www.process-one.net/downloads/ejabberd/15.03/ejabberd-15.03.tgz"
  sha256 "b685cd615ecd9a4f42701541e84c2a28ae534bc608d292b78145d9c59ea17233"

  head "https://github.com/processone/ejabberd.git"

  bottle do
    sha256 "9063f60e34c2fc8bbeb4eb6024b25dee054d4d281137bbd307fdec9610fa4ccd" => :yosemite
    sha256 "672cd019c4e79dccf422e0d7919bbdf7b5ea559b3457009ed8f87c5e9e4b4185" => :mavericks
    sha256 "12d8203a77c7f7775cf9f6fa703a4b756555cd06f111380bd47c23eafe0d564c" => :mountain_lion
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
            "--enable-pam"]

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
