class Openvpn < Formula
  desc "SSL VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/index.php/download/community-downloads.html"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.3.8.tar.gz"
  mirror "http://build.openvpn.net/downloads/releases/openvpn-2.3.8.tar.gz"
  sha256 "532435eff61c14b44a583f27b72f93e7864e96c95fe51134ec0ad4b1b1107c51"

  bottle do
    cellar :any
    sha256 "af7a9b8a5e3668a8edb5e008fe3fb1e9a142811aae41ebf86f33950d90440cfc" => :mavericks
    sha256 "ef56a0198dbd76e6b0fd9e3f5454027d011320e02ca7b359a63db13373faafd0" => :mountain_lion
  end

  depends_on "lzo"
  depends_on :tuntap
  depends_on "openssl"

  def install
    # pam_appl header is installed in a different location on Leopard
    # and older; reported upstream https://community.openvpn.net/openvpn/ticket/326
    if MacOS.version < :snow_leopard
      inreplace Dir["src/plugins/auth-pam/{auth-pam,pamdl}.c"],
        "security/pam_appl.h", "pam/pam_appl.h"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-crypto-library=openssl",
                          "--prefix=#{prefix}",
                          "--enable-password-save"
    system "make", "install"

    inreplace "sample/sample-config-files/openvpn-startup.sh",
      "/etc/openvpn", "#{etc}/openvpn"

    (doc/"sample").install Dir["sample/sample-*"]

    (etc+"openvpn").mkpath
    (var+"run/openvpn").mkpath
    # We don't use PolarSSL, so this file is unnecessary and somewhat confusing.
    rm "#{share}/doc/openvpn/README.polarssl"
  end

  def caveats; <<-EOS.undent
    If you have installed the Tuntap dependency as a source package you will
    need to follow the instructions found in `brew info tuntap`. If you have
    installed the binary Tuntap package, no further action is necessary.

    For OpenVPN to work as a server, you will need to create configuration file
    in #{etc}/openvpn, samples can be found in #{share}/doc/openvpn
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd";>
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/openvpn</string>
        <string>--config</string>
        <string>#{etc}/openvpn/openvpn.conf</string>
      </array>
      <key>OnDemand</key>
      <false/>
      <key>RunAtLoad</key>
      <true/>
      <key>TimeOut</key>
      <integer>90</integer>
      <key>WatchPaths</key>
      <array>
        <string>#{etc}/openvpn</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{etc}/openvpn</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{sbin}/openvpn", "--show-ciphers"
  end
end
