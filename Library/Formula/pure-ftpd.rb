class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "http://www.pureftpd.org/"
  url "http://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.41.tar.gz"
  mirror "ftp://ftp.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.41.tar.gz"
  sha256 "a877c689ae1b982c968a767631740a84f164ac2ae6312a4a2f9f93ba79a348e8"

  bottle do
    cellar :any
    sha256 "197b26f65f7c63ef7844f6d40dab6076b132cb6844d65a1c791546be42dd2a26" => :yosemite
    sha256 "d6e8c0cb8772b447202aa9774d3fc1c4c8857c2ff81875e40c0b935940a8e318" => :mavericks
    sha256 "c820d10085fbb7ad69a09f928da5d5994bbdee881520f07c5db3c5d1bf47b9dd" => :mountain_lion
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
