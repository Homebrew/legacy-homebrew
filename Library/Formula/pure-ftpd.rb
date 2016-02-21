class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.42.tar.gz"
  mirror "ftp://ftp.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.42.tar.gz"
  sha256 "7be73a8e58b190a7054d2ae00c5e650cb9e091980420082d02ec3c3b68d8e7f9"

  bottle do
    cellar :any
    revision 1
    sha256 "69135ddfc954654af6cf664027b0417b0d0bc5c075570efe368587f846f737e7" => :el_capitan
    sha256 "6569d0a5243612b9569da048c08a40b9826a2dcc231040ac2d2e4c12cd991eb5" => :yosemite
    sha256 "c97aa32a237cdfb02780d6808a42507ec8fa97345ef4f3332cfcfb6cce91ff1a" => :mavericks
  end

  depends_on "openssl"
  depends_on :postgresql => :optional
  depends_on :mysql => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-pam
      --with-altlog
      --with-puredb
      --with-throttling
      --with-ratios
      --with-quotas
      --with-ftpwho
      --with-virtualhosts
      --with-virtualchroot
      --with-diraliases
      --with-peruserlimits
      --with-tls
      --with-bonjour
    ]

    args << "--with-pgsql" if build.with? "postgresql"
    args << "--with-mysql" if build.with? "mysql"

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
