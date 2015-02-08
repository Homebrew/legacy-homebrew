require "formula"

class Etcd < Formula
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v2.0.0.tar.gz"
  sha1 "56c1334c28d1013cfeee725ec864762cf8a13779"
  head "https://github.com/coreos/etcd.git"

  bottle do
    sha1 "ce4c0100d8b80cd1ccf654d21561c1f0124fdddb" => :yosemite
    sha1 "1296fb789c837c58149ff01794f4bab6509aa584" => :mavericks
    sha1 "ab9d979ce7867cf64c027bf915689ec6dd8bfdb3" => :mountain_lion
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
