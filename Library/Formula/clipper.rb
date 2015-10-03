class Clipper < Formula
  desc "Share OS X clipboard with tmux and other local and remote apps"
  homepage "https://wincent.com/products/clipper"
  url "https://github.com/wincent/clipper/archive/0.2.tar.gz"
  sha256 "4c202238e37ed313d467d933c6fd815f095e7e7c225208b2b710f981d58df72a"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "clipper.go"
    bin.install "clipper"
  end

  plist_options :manual => "clipper"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/clipper</string>
        <string>--address</string>
        <string>127.0.0.1</string>
        <string>--port</string>
        <string>8377</string>
      </array>
      <key>EnvironmentVariables</key>
      <dict>
        <key>LANG</key>
        <string>en_US.UTF-8</string>
      </dict>
    </dict>
    </plist>
    EOS
  end
end
