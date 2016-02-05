class Clipper < Formula
  desc "Share OS X clipboard with tmux and other local and remote apps"
  homepage "https://wincent.com/products/clipper"
  url "https://github.com/wincent/clipper/archive/0.2.tar.gz"
  sha256 "4c202238e37ed313d467d933c6fd815f095e7e7c225208b2b710f981d58df72a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "ceb6758622ac2c16d9900545062e7ac1f6781bea459eaf3d0d56b39b98e83755" => :el_capitan
    sha256 "f21cdd8e00ada62a7f0379b89496721a3856878f54de6392c1315f6d51d6a69a" => :yosemite
    sha256 "c4cb851a2fb01a5874a6678d306c06ba64b4cd8ce8323363236cadd0713e256c" => :mavericks
  end

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
