class Openvpn < Formula
  desc "SSL VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/index.php/download/community-downloads.html"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.3.9.tar.gz"
  mirror "http://build.openvpn.net/downloads/releases/openvpn-2.3.9.tar.gz"
  sha256 "2c12fe9ea641ac1291e70322cc500641c84e5903dd4f40bf2eda7e9f209b2f9c"

  bottle do
    cellar :any
    revision 1
    sha256 "882a30fe91692b21da5a003d392bc87c87abd2e064a51f6466c95cf0b25924ce" => :el_capitan
    sha256 "4da6b041921df90a929821be483a67e3bb3e0a5ea4b28aed9a93cbab706b45e8" => :yosemite
    sha256 "c2fb3da6a522f8f64330c238c9e5266cdea1d23e908113bb2b82eeb80f3e884d" => :mavericks
  end

  depends_on "lzo"
  depends_on :tuntap if MacOS.version < :yosemite
  depends_on "openssl"
  depends_on "pkcs11-helper" => :optional

  if build.with? "pkcs11-helper"
    depends_on "pkg-config" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # pam_appl header is installed in a different location on Leopard
    # and older; reported upstream https://community.openvpn.net/openvpn/ticket/326
    if MacOS.version < :snow_leopard
      inreplace Dir["src/plugins/auth-pam/{auth-pam,pamdl}.c"],
        "security/pam_appl.h", "pam/pam_appl.h"
    end

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-crypto-library=openssl
      --prefix=#{prefix}
      --enable-password-save
    ]

    args << "--enable-pkcs11" if build.with? "pkcs11-helper"

    system "./configure", *args

    system "make", "install"

    inreplace "sample/sample-config-files/openvpn-startup.sh",
      "/etc/openvpn", "#{etc}/openvpn"

    (doc/"sample").install Dir["sample/sample-*"]

    (etc+"openvpn").mkpath
    (var+"run/openvpn").mkpath
    # We don't use PolarSSL, so this file is unnecessary and somewhat confusing.
    rm "#{share}/doc/openvpn/README.polarssl"
  end

  def caveats
    s = ""

    if MacOS.version < :yosemite
      s += <<-EOS.undent
        If you have installed the Tuntap dependency as a source package you will
        need to follow the instructions found in `brew info tuntap`. If you have
        installed the binary Tuntap package, no further action is necessary.

      EOS
    end

    s += <<-EOS.undent
      For OpenVPN to work as a server, you will need to create configuration file
      in #{etc}/openvpn, samples can be found in #{share}/doc/openvpn
    EOS

    s
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
