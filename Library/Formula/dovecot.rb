class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "http://dovecot.org/"
  url "http://dovecot.org/releases/2.2/dovecot-2.2.18.tar.gz"
  mirror "https://fossies.org/linux/misc/dovecot-2.2.18.tar.gz"
  sha256 "b6d8468cea47f1227f47b80618f7fb872e2b2e9d3302adc107a005dd083865bb"

  bottle do
    sha256 "2d1e25f40b1006b08da06e87f5b363d4b9654e6c936d7388d2b85239c7e202be" => :yosemite
    sha256 "f26ea1738aba89131294f2ae229799af0a7e2c4b704362da248563d6b94c4a95" => :mavericks
    sha256 "5b5f8427b67da36ce686c14d0fc9230fe42884e69c116d46d8eca37f86e79c8a" => :mountain_lion
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
        <key>OnDemand</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/dovecot</string>
          <string>-F</string>
        </array>
        <key>ServiceDescription</key>
        <string>Dovecot mail server</string>
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
