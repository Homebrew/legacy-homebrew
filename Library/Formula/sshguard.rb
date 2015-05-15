class Sshguard < Formula
  homepage "http://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/1.6.0/sshguard-1.6.0.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sshguard/sshguard_1.6.0.orig.tar.xz"
  sha256 "dce32b1fc3fb0f8d15b6c56b9822c300434faaa87240e5373c095dc22bfa07e4"

  bottle do
    sha256 "f7a9e63682d2aeec6857103923c3b8d3337505137e7d7f465b01b28c6b59cf11" => :yosemite
    sha256 "34ebca7be518eef199e2fd17e1211ffe107568a5c0cabb77db3ee8635ffc3104" => :mavericks
    sha256 "9d3bb789cad856e82c61d034a2ab2fe31b7dffea072066fedc176f6ed7a66ad7" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  # Fix blacklist flag (-b) so that it doesn't abort on first usage.
  # Upstream bug report:
  # http://sourceforge.net/tracker/?func=detail&aid=3252151&group_id=188282&atid=924685
  patch do
    url "http://sourceforge.net/p/sshguard/bugs/_discuss/thread/3d94b7ef/c062/attachment/sshguard.c.diff"
    sha1 "68cd0910d310e4d23e7752dee1b077ccfe715c0b"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-firewall=#{firewall}"
    system "make", "install"
  end

  def firewall
    MacOS.version >= :lion ? "pf" : "ipfw"
  end

  def log_path
    MacOS.version >= :lion ? "/var/log/system.log" : "/var/log/secure.log"
  end

  def caveats
    if MacOS.version >= :lion then <<-EOS.undent
      Add the following lines to /etc/pf.conf to block entries in the sshguard
      table (replace $ext_if with your WAN interface):

        table <sshguard> persist
        block in quick on $ext_if proto tcp from <sshguard> to any port 22 label "ssh bruteforce"

      Then run sudo pfctl -f /etc/pf.conf to reload the rules.
      EOS
    end
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>KeepAlive</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/sshguard</string>
        <string>-l</string>
        <string>#{log_path}</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/sshguard -v 2>&1", 1)
  end
end
