class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.42.tar.gz"
  mirror "ftp://ftp.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.42.tar.gz"
  sha256 "7be73a8e58b190a7054d2ae00c5e650cb9e091980420082d02ec3c3b68d8e7f9"

  bottle do
    cellar :any
    sha256 "c4c87894367f61c7d0ac221cef3c39c1e57b52b8844b6c3bbef997963f5bdda1" => :el_capitan
    sha256 "00bbca99a4a622ec8342a1e554ec9cbc018537bde79b0de54f392d3189ad0068" => :yosemite
    sha256 "cbb8ac81c98ebba08a6be8dd93ce7cfbca91fd2dc53f4a4388b46a2901dccefd" => :mavericks
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
