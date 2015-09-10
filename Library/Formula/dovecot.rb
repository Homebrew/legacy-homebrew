class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "http://dovecot.org/"
  url "http://dovecot.org/releases/2.2/dovecot-2.2.18.tar.gz"
  mirror "https://fossies.org/linux/misc/dovecot-2.2.18.tar.gz"
  sha256 "b6d8468cea47f1227f47b80618f7fb872e2b2e9d3302adc107a005dd083865bb"

  bottle do
    revision 1
    sha256 "b0213868f3a9db6992b04d688209c8d35aa472beeb2fd03b937f112857e7f0c0" => :yosemite
    sha256 "03c6c26881f816b9206efe6ff97df76ceb179696466f8f177ce3d625ad270e2c" => :mavericks
    sha256 "54ed311a625d029291a644117a3a16c0d9b5ab1158c0ceffe229635ca3a62008" => :mountain_lion
  end

  depends_on "openssl"
  depends_on "clucene" => :optional

  option "with-pam", "Build with PAM support"

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

    system "./configure",  *args
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
