class Etcd < Formula
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v2.0.8.tar.gz"
  sha256 "95155b04fb4b1e7e86f064d4b9f8858addd102dad589300a039f4c1a0227f983"
  head "https://github.com/coreos/etcd.git"

  bottle do
    sha256 "41f81923a5c7c2fafb2ec1f6c95d354daea8986cf32c4fca56735180fd130a03" => :yosemite
    sha256 "e3ca3ccf596d76b9a60060e80edc691928617b39df93c5a7dac1bf41895c4554" => :mavericks
    sha256 "d2ca6ebfe34d406deed30968f491def63c1e06b1239f605203c6ce1990a4d564" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/etcd"
    bin.install "bin/etcdctl"
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
