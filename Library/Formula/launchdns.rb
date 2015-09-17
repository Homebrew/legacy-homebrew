class Launchdns < Formula
  desc "Mini DNS server designed soely to route queries to localhost"
  homepage "https://github.com/josh/launchdns"
  url "https://github.com/josh/launchdns/archive/v1.0.3.tar.gz"
  head "https://github.com/josh/launchdns.git"
  sha256 "c34bab9b4f5c0441d76fefb1ee16cb0279ab435e92986021c7d1d18ee408a5dd"

  depends_on :macos => :yosemite

  bottle do
    cellar :any_skip_relocation
    sha256 "d9434fae9c609c44264c90bef1e52b66db7f1ce2ef12cb8f2498a89d2ba4d0e0" => :el_capitan
    sha256 "bdc3fea3f9a6c59908a2b81f1d3bb373dbe807efe62f4b6e0c00fac4dbf0d2c7" => :yosemite
  end

  def install
    ENV["PREFIX"] = prefix
    system "./configure", "--with-launch-h", "--with-launch-h-activate-socket"
    system "make", "install"

    (prefix+"etc/resolver/dev").write("nameserver 127.0.0.1\nport 55353\n")
  end

  test do
    assert_no_match /without socket activation/, shell_output("#{bin}/launchdns --version")
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
