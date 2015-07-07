class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "http://dnscrypt.org"
  url "https://github.com/jedisct1/dnscrypt-proxy/releases/download/1.5.0/dnscrypt-proxy-1.5.0.tar.bz2"
  mirror "http://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-proxy-1.5.0.tar.bz2"
  sha256 "dd1a09baff5685cf939c429ba0258f66a79d464bc5ac130d8d30e667fb8ee3b2"

  bottle do
    sha256 "e7062b1b7be9232ae720c10a8408947979d067309f858876d69f840682f4c232" => :yosemite
    sha256 "d68a2f9232aff5b1565221fbd188dd0a763cca36bde24edfc7bc41414c06fa93" => :mavericks
    sha256 "13a888618cccd52d7fc902fd209d9c681cbf760f06306022f17bdf94e098cf3a" => :mountain_lion
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

  test do
    system "#{sbin}/dnscrypt-proxy", "--version"
  end
end
