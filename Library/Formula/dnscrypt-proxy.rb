class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.org"
  url "https://github.com/jedisct1/dnscrypt-proxy/releases/download/1.6.0/dnscrypt-proxy-1.6.0.tar.bz2"
  mirror "https://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-proxy-1.6.0.tar.bz2"
  sha256 "e0cce91dc6ab4ed76478579a899b2abb888b1d7ed133cb55294c2f9ce24edc7d"
  revision 1

  bottle do
    sha256 "79f10a11a46ccb906dc3faa94d452ebf8a2fab8de430504b0cd0fae4cab9a45f" => :el_capitan
    sha256 "83a96898f5e0d04372adbd720a41c2bc5b9dbb4ff621ffb2d908f83c6c5a07f4" => :yosemite
    sha256 "7c62d485032663d00cb071f5a511637e3aee8642a0ed0afaa10567b855199adb" => :mavericks
  end

  head do
    url "https://github.com/jedisct1/dnscrypt-proxy.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-plugins", "Support plugins and install example plugins."

  deprecated_option "plugins" => "with-plugins"

  depends_on "libsodium"

  def install
    system "autoreconf", "-if" if build.head?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    if build.with? "plugins"
      args << "--enable-plugins"
      args << "--enable-relaxed-plugins-permissions"
      args << "--enable-plugins-root"
    end

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    After starting dnscrypt-proxy, you will need to point your
    local DNS server to 127.0.0.1. You can do this by going to
    System Preferences > "Network" and clicking the "Advanced..."
    button for your interface. You will see a "DNS" tab where you
    can click "+" and enter 127.0.0.1 in the "DNS Servers" section.

    By default, dnscrypt-proxy runs on localhost (127.0.0.1), port 53,
    and under the "nobody" user using the dnscrypt.eu-dk DNSCrypt-enabled
    resolver. If you would like to change these settings, you will have to edit
    the plist file (e.g., --resolver-address, --provider-name, --provider-key, etc.)

    To check that dnscrypt-proxy is working correctly, open Terminal and enter the
    following command. Replace en1 with whatever network interface you're using:

        sudo tcpdump -i en1 -vvv 'port 443'

    You should see a line in the result that looks like this:

        resolver2.dnscrypt.eu.https
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-/Apple/DTD PLIST 1.0/EN" "http:/www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/dnscrypt-proxy</string>
          <string>--ephemeral-keys</string>
          <string>--resolvers-list=#{share}/dnscrypt-proxy/dnscrypt-resolvers.csv</string>
          <string>--resolver-name=dnscrypt.eu-dk</string>
          <string>--user=nobody</string>
        </array>
        <key>UserName</key>
        <string>root</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{sbin}/dnscrypt-proxy", "--version"
  end
end
