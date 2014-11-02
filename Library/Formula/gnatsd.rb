require "formula"

class Gnatsd < Formula
  homepage "http://nats.io"
  url "https://github.com/apcera/gnatsd/archive/v0.5.6.tar.gz"
  head "https://github.com/apcera/gnatsd.git"
  sha1 "b22a0252b838cff91586fb02d9efe31b428e5be2"

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
