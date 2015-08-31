class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v2.1.2.tar.gz"
  sha256 "e4e7dc83e5d1686e668ca866cb026d281b62f596666325057ae3c2ec9ab991a7"
  head "https://github.com/coreos/etcd.git"

  bottle do
    cellar :any
    sha256 "4c97c87860af27c0c6ebb8a6ae9477490a8f40858a2f820839cb4ce757f1de9f" => :yosemite
    sha256 "fd2d62105f88d4719a869022d5dae07cbc1543b3da767badf2f3f133db75cbf7" => :mavericks
    sha256 "e77d103b978601823baf7e73cd5f3bf68b49640585d248d9a514ed950568f6af" => :mountain_lion
  end

  devel do
    url "https://github.com/coreos/etcd/archive/v2.2.0-rc.0.tar.gz"
    version "2.2.0-rc.0"
    sha256 "fae915a409321866ca5fc253a5b5a7f2501dfbc8cb8dc54e574db7c6666f82e3"
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
