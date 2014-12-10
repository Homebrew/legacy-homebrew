require "formula"

class Unbound < Formula
  homepage "http://www.unbound.net"
  url "http://unbound.net/downloads/unbound-1.5.1.tar.gz"
  sha256 "0ff82709fb2bd7ecbde8dbdcf60fa417d2b43379570a3d460193a76a169900ec"

  depends_on "openssl"
  depends_on "libevent"

  bottle do
    sha1 "98610e627047f9a5df8b8a2fed73b6d3f5153f31" => :yosemite
    sha1 "e29b138c0d056405e98bd4c86282c2ac3072c1c9" => :mavericks
    sha1 "ba39f11d28f588616c0a0bc6f42197856c6035e5" => :mountain_lion
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
