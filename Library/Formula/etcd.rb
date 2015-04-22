class Etcd < Formula
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v2.0.9.tar.gz"
  sha256 "a03c44fa125a3058c4cec0704136485b6031163108399969ba4a0e19f98dcf23"
  head "https://github.com/coreos/etcd.git"

  bottle do
    sha256 "870f5f666aa3f07d6ca11825a4f052dfcd1057d6e8d9492e5ad786a587ecde84" => :yosemite
    sha256 "8c21a563a19ec03d7424523e91b4c091bc51c55d447b8db0fb15488d147c0486" => :mavericks
    sha256 "92960a6f1bcf2e87b4b0621294ce61c9a5586395e5509379132e5507ddeecb8a" => :mountain_lion
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
