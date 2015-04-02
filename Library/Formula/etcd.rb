class Etcd < Formula
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v2.0.8.tar.gz"
  sha256 "95155b04fb4b1e7e86f064d4b9f8858addd102dad589300a039f4c1a0227f983"
  head "https://github.com/coreos/etcd.git"

  bottle do
    sha256 "4b8834b4e30d3a1b844c44c9d45fd56cc0c0ecd622fd25f9839c66951e8c4b9a" => :yosemite
    sha256 "0fc622368c5a64ac24f85260fb1d571b9eedb8dbec9283134adf33ee1f17295b" => :mavericks
    sha256 "3516319b664ce4bfea142f32a8844fa78d79f590b94c953cb29fcd3b6ad22c90" => :mountain_lion
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
