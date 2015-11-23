class Gnatsd < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/gnatsd/archive/v0.6.8.tar.gz"
  sha256 "13dfc0ef51feaa52fc347d12a972ed800ff1f2a6a816e988ce38bf1dfce1d8eb"
  head "https://github.com/apcera/gnatsd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f535cf9e5a9f76b148f937da21ab66fa8998fd2b1efeebe57a927dbe6d54049" => :el_capitan
    sha256 "09d43712f376ea345183662c585a5334cc23e8933aa83bf1862a1d6dac4784f3" => :yosemite
    sha256 "3fda8657a9758ebbbb305236e9b04fdfbfec556b8c6924e58caa17a4513debbc" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/nats-io"
    ln_s buildpath, "src/github.com/nats-io/gnatsd"
    system "go", "install", "github.com/nats-io/gnatsd"
    system "go", "build", "-o", bin/"gnatsd", "gnatsd.go"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/gnatsd</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    system "gnatsd", "-v"
  end
end
