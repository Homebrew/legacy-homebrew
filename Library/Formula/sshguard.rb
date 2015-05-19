class Sshguard < Formula
  desc "Protect from brute force attacks against SSH"
  homepage "http://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/1.6.0/sshguard-1.6.0.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sshguard/sshguard_1.6.0.orig.tar.xz"
  sha256 "dce32b1fc3fb0f8d15b6c56b9822c300434faaa87240e5373c095dc22bfa07e4"

  bottle do
    cellar :any
    sha256 "5fd4d11c40756356476a882a5ef8317ade15d163eb7b5b402e9b3e4474dbb1d7" => :yosemite
    sha256 "e272de3bb7284d8dfb930295d0dc310666bcf807356d9af80b31e2e6e4bd5a7e" => :mavericks
    sha256 "16d633776b9b44032a3c3067851217193fdd7e2984ae881d7aece14cca772b13" => :mountain_lion
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
