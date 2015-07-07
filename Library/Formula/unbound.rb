require "formula"

class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://unbound.net/downloads/unbound-1.5.3.tar.gz"
  sha256 "76bdc875ed4d1d3f8e4cfe960e6df78ee5c6c7c18abac11331cf93a7ae129eca"

  depends_on "openssl"
  depends_on "libevent"

  bottle do
    sha256 "4ec2891a47855facb66da9178f966cb524ed725c328f8a8278764676049d048e" => :yosemite
    sha256 "7e0775a27cae29b72fe55e1b74f8dad51fa413a0ffba924b79d7c18d0d5d916d" => :mavericks
    sha256 "a977d1f977b7ee9abe834cefff90d29f3e3d878ee09ff066adfcc616cdf859b1" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
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
          <string>#{opt_sbin}/unbound</string>
          <string>-d</string>
          <string>-c</string>
          <string>#{etc}/unbound/unbound.conf</string>
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
