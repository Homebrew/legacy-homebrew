require "language/go"

class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://github.com/bitly/oauth2_proxy"
  url "https://github.com/bitly/oauth2_proxy/archive/v2.0.1.tar.gz"
  sha256 "febc33244d63f69a4c973e4ff2556fea2bc414308ce9979fb43db5863da87b5a"
  head "https://github.com/bitly/oauth2_proxy.git"

  bottle do
    cellar :any
    sha256 "dcb93accc34447cccc4306c42804b8b9adb409556d9922a03be1cced4fe28e9a" => :yosemite
    sha256 "f6f33eb43df4fd594f0df9bfb3931b66f3e3399152e5021add31bfa41199a439" => :mavericks
    sha256 "b1b6486c7218d727c911825337c59d2531dedc4219116164d1414610a149fe06" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
      :revision => "056c9bc7be7190eaa7715723883caffa5f8fa3e4"
  end

  go_resource "github.com/bitly/go-simplejson" do
    url "https://github.com/bitly/go-simplejson.git",
      :revision => "18db6e68d8fd9cbf2e8ebe4c81a78b96fd9bf05a"
  end

  go_resource "github.com/mreiferson/go-options" do
    url "https://github.com/mreiferson/go-options.git",
      :revision => "7c174072188d0cfbe6f01bb457626abb22bdff52"
  end

  go_resource "gopkg.in/fsnotify.v1" do
    url "https://gopkg.in/fsnotify.v1.git",
      :revision => "96c060f6a6b7e0d6f75fddd10efeaca3e5d1bcb0"
  end

  def install
    mkdir_p "#{buildpath}/src/github.com/bitly"
    ln_s buildpath, "#{buildpath}/src/github.com/bitly/oauth2_proxy"

    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", "#{bin}/oauth2_proxy"
    doc.install "README.md"
    (etc/"oauth2_proxy").install "contrib/oauth2_proxy.cfg.example"
  end

  def caveats; <<-EOS.undent
    #{etc}/oauth2_proxy/oauth2_proxy.cfg must be filled in.
    EOS
  end

  test do
    require "socket"
    require "timeout"

    # Get an unused TCP port.
    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    pid = fork do
      exec "#{bin}/oauth2_proxy",
        "--client-id=testing",
        "--client-secret=testing",
        "--cookie-secret=testing",
        "--http-address=127.0.0.1:#{port}",
        "--upstream=127.0.0.1:1234"
    end

    begin
      Timeout.timeout(10) do
        loop do
          Utils.popen_read "curl", "-s", "http://127.0.0.1:#{port}"
          break if $?.exitstatus == 0
          sleep 1
        end
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/oauth2_proxy</string>
            <string>--config=#{etc}/oauth2_proxy/oauth2_proxy.cfg</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
