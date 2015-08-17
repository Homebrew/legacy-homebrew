class Launchdns < Formula
  desc "Mini DNS server designed soely to route queries to localhost"
  homepage "https://github.com/josh/launchdns"
  url "https://github.com/josh/launchdns/archive/v1.0.1.tar.gz"
  head "https://github.com/josh/launchdns.git"
  sha256 "e96d1b92819a294f1e325df629ae4bf202fd137b8504cf4ddd00cda7e47f7099"

  bottle do
    sha1 "592ca0ff9d89f00613dd850be91fa15a8d2cfc6a" => :yosemite
    sha1 "9ff650e25b17a1f29e9965c5e5bc678fc82d32aa" => :mavericks
    sha1 "ffb5f5e33aa4429c4ada07f5992dbef2853b2cb5" => :mountain_lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"

    (prefix+"etc/resolver/dev").write("nameserver 127.0.0.1\nport 55353\n")
  end

  test do
    system "#{bin}/launchdns", "-p0", "-t1"
  end

  def caveats; <<-EOS.undent
      To have *.dev resolved to 127.0.0.1:
          sudo ln -s #{HOMEBREW_PREFIX}/etc/resolver /etc/resolver
    EOS
  end

  plist_options :manual => "launchdns"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/launchdns</string>
          <string>--socket=Listeners</string>
          <string>--timeout=30</string>
        </array>
        <key>Sockets</key>
        <dict>
          <key>Listeners</key>
          <dict>
            <key>SockType</key>
            <string>dgram</string>
            <key>SockNodeName</key>
            <string>127.0.0.1</string>
            <key>SockServiceName</key>
            <string>55353</string>
          </dict>
        </dict>
      </dict>
    </plist>
    EOS
  end
end
