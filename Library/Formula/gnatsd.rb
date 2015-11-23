class Gnatsd < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/apcera/gnatsd/archive/v0.6.0.tar.gz"
  sha256 "de495dc1b52e16a61e2750bcab29a6c9de2a57c591476740dcbae3134494e1c1"
  head "https://github.com/apcera/gnatsd.git"

  bottle do
    cellar :any
    sha256 "106c9bbfddbe20ce2a0e0df337b365df34cefe20a824e78be8d37d09521a14e0" => :yosemite
    sha256 "b95020cc3e1a0050320c087a2fd454e275e2031bd1c304fc59ac6af3b23908de" => :mavericks
    sha256 "4d3caabcd86477fb34213524a0aedff60751931acc37b5d9a23c63d81a08170b" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/apcera"
    ln_s buildpath, "src/github.com/apcera/gnatsd"
    system "go", "install", "github.com/apcera/gnatsd"
    system "go", "build", "gnatsd.go"

    bin.install "gnatsd"
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
