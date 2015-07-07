class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "http://www.pureftpd.org/"
  url "http://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.37.tar.gz"
  mirror "ftp://ftp.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.37.tar.gz"
  sha256 "a9c10b0b8b5772fbf2212bc46fece86f9d4bcc07e58dfd83b58e42a1b2acb76c"

  depends_on "openssl"

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}",
            "--sysconfdir=#{etc}",
            "--with-pam",
            "--with-altlog",
            "--with-puredb",
            "--with-throttling",
            "--with-ratios",
            "--with-quotas",
            "--with-ftpwho",
            "--with-virtualhosts",
            "--with-virtualchroot",
            "--with-diraliases",
            "--with-peruserlimits",
            "--with-tls",
            "--with-bonjour"]

    args << "--with-pgsql" if which "pg_config"
    args << "--with-mysql" if which "mysql"

    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "pure-ftpd"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/pure-ftpd</string>
          <string>-A -j -z</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/pure-ftpd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/pure-ftpd.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"pure-pw", "--help"
  end
end
