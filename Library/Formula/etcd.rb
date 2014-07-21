require "formula"

class Etcd < Formula
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v0.4.5.tar.gz"
  sha1 "ddfc8a6ed4804fdd8f5785b286522bb7ae15a95d"
  head "https://github.com/coreos/etcd.git"

  bottle do
    sha1 "2e6b56281c35da746017d604f5c7b3de53e6f739" => :mavericks
    sha1 "7578c221fd84d8ebc83e4413fd719d2be42bed99" => :mountain_lion
    sha1 "ccf8dd7b01d62ed1e5a19ce035ef6ada9a0b327d" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/etcd"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/etcd</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
    EOS
  end
end
