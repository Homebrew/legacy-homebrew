class Launchdns < Formula
  desc "Mini DNS server designed soely to route queries to localhost"
  homepage "https://github.com/josh/launchdns"
  url "https://github.com/josh/launchdns/archive/v1.0.1.tar.gz"
  head "https://github.com/josh/launchdns.git"
  sha256 "e96d1b92819a294f1e325df629ae4bf202fd137b8504cf4ddd00cda7e47f7099"

  bottle do
    cellar :any
    revision 1
    sha256 "e09023cdbc899359414a8838b20e0221243a4bf2d34f6d3fc2f5671f0f64c04a" => :el_capitan
    sha256 "3b6276a21a4a1523d6e14d34ae7332c7f39ee2544b61bfad2b32dcb9f0761576" => :yosemite
    sha256 "7075bad8ec1f01f4b8deb59492b406bf4915d1e249aa0ea44d2615646af25bde" => :mavericks
    sha256 "3b7e3ac513be0817414d7930f524887da956f331a7344df555e4c4c1083a7e43" => :mountain_lion
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
          sudo ln -s #{HOMEBREW_PREFIX}/etc/resolver /etc
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
