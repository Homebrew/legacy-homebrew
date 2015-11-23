class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "http://dovecot.org/"
  url "http://dovecot.org/releases/2.2/dovecot-2.2.18.tar.gz"
  mirror "https://fossies.org/linux/misc/dovecot-2.2.18.tar.gz"
  sha256 "b6d8468cea47f1227f47b80618f7fb872e2b2e9d3302adc107a005dd083865bb"

  bottle do
    revision 2
    sha256 "7cd19bd919795c966252e4fe1208e82a45479b02dd2bc7af083a5076b4256b7f" => :el_capitan
    sha256 "086923e8cbcda311630328f76df479b7362c2966d349f7e05b855404f6610d3f" => :yosemite
    sha256 "23d888317ae30125f810ad24a2110af0f79be47e0104abecb5dd78a972803309" => :mavericks
  end

  option "with-pam", "Build with PAM support"

  depends_on "openssl"
  depends_on "clucene" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-ssl=openssl
      --with-sqlite
      --with-zlib
      --with-bzlib
    ]

    args << "--with-lucene" if build.with? "clucene"
    args << "--with-pam" if build.with? "pam"

    system "./configure", *args
    system "make", "install"
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/dovecot</string>
          <string>-F</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/dovecot/dovecot.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/dovecot/dovecot.log</string>
      </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    For Dovecot to work, you may need to create a dovecot user
    and group depending on your configuration file options.
    EOS
  end

  test do
    assert_match /#{version}/, shell_output("#{sbin}/dovecot --version")
  end
end
