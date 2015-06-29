class Gnatsd < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/apcera/gnatsd/archive/v0.6.0.tar.gz"
  sha256 "de495dc1b52e16a61e2750bcab29a6c9de2a57c591476740dcbae3134494e1c1"
  head "https://github.com/apcera/gnatsd.git"

  bottle do
    sha1 "f430b3bae19808ceaa007a681b9b5fe9704ff6e3" => :yosemite
    sha1 "a17cccfd22645af9f895a23a1adc1a65a6bd6852" => :mavericks
    sha1 "5699c0b45fd4f38d3a24555eef856435cd6e257b" => :mountain_lion
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
