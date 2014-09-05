require "formula"

class Etcd < Formula
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v0.4.6.tar.gz"
  sha1 "80b405fd01527eea6668fde0186ca6b119c1185c"
  head "https://github.com/coreos/etcd.git"

  bottle do
    sha1 "dd7aff45b8fb94304047015343d03d692f7a991f" => :mavericks
    sha1 "e548cb1d29e4d0b5a78a6cd9e30034fb669e8c5a" => :mountain_lion
    sha1 "bc35b7c3315e899f4e6b96c9db7615de03c04dbd" => :lion
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
