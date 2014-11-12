require "formula"

class Unbound < Formula
  homepage "http://www.unbound.net"
  url "http://unbound.net/downloads/unbound-1.4.22.tar.gz"
  sha256 "1caf5081b2190ecdb23fc4d998b7999e28640c941f53baff7aee03c092a7d29f"
  revision 1

  depends_on "openssl"
  depends_on "libevent"

  bottle do
    sha1 "e0146e449a9b72fd80760c11f093c35595db0c86" => :yosemite
    sha1 "07d53e51e9ffda66e655ce44ee888fd46fac0d3e" => :mavericks
    sha1 "774744eb63626555c9877ce857e0a774e961f428" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--sysconfdir=#{etc}"
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
