require "formula"

class DnscryptProxy < Formula
  homepage "http://dnscrypt.org"
  url "https://github.com/jedisct1/dnscrypt-proxy/releases/download/1.4.2/dnscrypt-proxy-1.4.2.tar.bz2"
  mirror "http://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-proxy-1.4.2.tar.bz2"
  sha256 "766bcd8874cd6cbfeeeb7246c75c39ddc14317ad81ad713bd6cfc9529b2f0c0d"

  bottle do
    sha1 "2a09152f68e40dd76d2415cb7afebf0480881578" => :yosemite
    sha1 "80fa7111d860b34bb312381886e2b73128db906e" => :mavericks
    sha1 "401db4fb2a2dcee39edcbeb8b04e30ef669a8b4a" => :mountain_lion
  end

  head do
    url "https://github.com/jedisct1/dnscrypt-proxy.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "plugins", "Support plugins and install example plugins."

  depends_on "libsodium"

  def install
    system "autoreconf", "-if" if build.head?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    if build.include? "plugins"
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
    and under the "nobody" user using the default OpenDNS DNSCrypt-enabled
    resolver. If you would like to change these settings (e.g., switching to
    a DNSCrypt-enabled resolver with DNSSEC support), you will have to edit the
    plist file (e.g., --resolver-address, --provider-name, --provider-key, etc.)

    To check that dnscrypt-proxy is working correctly, open Terminal and enter the
    following command:

        dig txt debug.opendns.com

    You should see a line in the result that looks like this:

        debug.opendns.com.	0	IN	TXT	"dnscrypt enabled (......)"

    Note: This will only work if you are using the default OpenDNS DNSCrypt-enabled
    resolver. If you are using a different resolver, you can use a tool like tcpdump
    to verify that everything is working correctly.
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
          <string>--user=nobody</string>
          <string>--resolver-name=opendns</string>
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
end
