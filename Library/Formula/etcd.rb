class Etcd < Formula
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v2.0.4.tar.gz"
  sha256 "37bba9ef5046df3d3b09789d87ef7e2186a32ceea400a94f3edc1efd10789e53"
  head "https://github.com/coreos/etcd.git"

  bottle do
    sha256 "821841848d23eb547ad98612f4e4048a1e47189bc9a18cbf3826ed3c86180510" => :yosemite
    sha256 "d319db0e1163f7c66606c42f672f5405ddc206b1f5665928d5a1f03469809b9e" => :mavericks
    sha256 "76ef13aa736e2f9480c99175db429a389c67e825b786291dff3b374fa36121d5" => :mountain_lion
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
