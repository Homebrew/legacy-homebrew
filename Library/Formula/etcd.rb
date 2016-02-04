class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v2.2.5.tar.gz"
  sha256 "a7fb7998ada620fda74e517c100891d25a15a6fa20b627df52da7cd29328e6d5"
  head "https://github.com/coreos/etcd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0318a7cadc81304d8f9ec46daacbd52c240418afb1313db3030d13ff0fdb7c7f" => :el_capitan
    sha256 "e495f8599b5c4cecc2b25d2747fcb084f3db1f9f06da8e80f135a911c3b960c7" => :yosemite
    sha256 "96fcdb5e45e6e40c2a57d3a05b54d5d145ff8ebf3b36871b16fcc6b6b3e76a76" => :mavericks
  end

  devel do
    url "https://github.com/coreos/etcd/archive/v2.3.0-alpha.0.tar.gz"
    version "2.3.0-alpha.0"
    sha256 "6603684824a650c472c791fc7c4cdf6811920f473e01bcfe8b1d95b0fd1f25c6"
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
