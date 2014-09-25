require "formula"

class Ejabberd < Formula
  homepage "http://www.ejabberd.im"
  url "https://www.process-one.net/downloads/ejabberd/14.07/ejabberd-14.07.tgz"
  sha1 "321b28faedbc28f80664d4b301424b118dd0bad0"
  revision 1

  head 'https://github.com/processone/ejabberd.git'

  bottle do
    revision 1
    sha1 "bb51d214082e9e72f7f10f41d34dd0a3b5f81edf" => :mavericks
    sha1 "3850af04f591854230ec4158b62520f121e32232" => :mountain_lion
    sha1 "22871728227cb497381181794b8a7401d1c1beb8" => :lion
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
    # Homebrew's 'C compiler cannot create executables' bug workaround
    ENV["HOMEBREW_ARCHFLAGS"] = " "

    if build.build_32_bit?
      ENV.append %w{CFLAGS LDFLAGS}, "-arch #{Hardware::CPU.arch_32_bit}"
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
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/ejabberdctl</string>
        <string>start</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

end
