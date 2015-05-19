class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v2.0.10.tar.gz"
  sha256 "6029113d9870e5c6f0d10adbd2b6670958a46575114a094b86b607771a0e5ff3"
  head "https://github.com/coreos/etcd.git"

  bottle do
    cellar :any
    sha256 "b1bb954e636b25d75d41f3119c817b67bf3b3dcbd37dca7e95f79ada8782a506" => :yosemite
    sha256 "c0af5a4ef05c4c09e4a2e20610cbc49e6cc6bb389f79f84f03497da44ed631f0" => :mavericks
    sha256 "09d0f70cfcce1a5e5e922d39d4d3f232adc1a08beb3a2a00dd282fcb6c4f95ac" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/etcd"
    bin.install "bin/etcdctl"
  end

  test do
    begin
      require "utils/json"
      test_string = "Hello from brew test!"
      etcd_pid = fork do
        exec "etcd", "--force-new-cluster", "--data-dir=#{testpath}"
      end
      # sleep to let etcd get its wits about it
      sleep 10
      etcd_uri = "http://127.0.0.1:4001/v2/keys/brew_test"
      system "curl", "--silent", "-L", etcd_uri, "-XPUT", "-d", "value=#{test_string}"
      curl_output = shell_output "curl --silent -L #{etcd_uri}"
      response_hash = Utils::JSON.load(curl_output)
      assert_match(test_string, response_hash.fetch("node").fetch("value"))
    ensure
      # clean up the etcd process before we leave
      Process.kill("HUP", etcd_pid)
    end
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
