class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.42.tar.gz"
  mirror "ftp://ftp.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.42.tar.gz"
  sha256 "7be73a8e58b190a7054d2ae00c5e650cb9e091980420082d02ec3c3b68d8e7f9"

  bottle do
    cellar :any
    revision 1
    sha256 "fbd04555e96661f04440ce349e04a7a4bf6fb5fddfe7dccea37916ef581d8b36" => :el_capitan
    sha256 "3fa9170128020e89f3dee1821dcfba81e641da3547382490a4d9c0d96345a1e0" => :yosemite
    sha256 "9d9b93ea06dc763761835a8cff7673670b9d57b28677a308683e4f9f67572126" => :mavericks
  end

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
