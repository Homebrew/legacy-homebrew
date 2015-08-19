class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "http://www.sonatype.org/"
  url "https://download.sonatype.com/nexus/oss/nexus-2.11.3-01-bundle.tar.gz"
  version "2.11.3-01"
  sha256 "a155a056a5ffe8b129200cbe83721f083ccb220fddffd19c737690804bc791c7"

  bottle do
    cellar :any
    sha256 "9faceac9f3b0eac6c78c6d400e6fe2c0f5f9eb38e5ee5f7507c93f60163c6cc6" => :yosemite
    sha256 "003848e3c5bda97a0f2983165b14ed5c81d93190e3585685b6d36e43413aae9e" => :mavericks
    sha256 "f33d6de510d225b97461465d360f741b11391b7c69d43200730c5d02959f789a" => :mountain_lion
  end

  def install
    rm_f Dir["bin/*.bat"]
    # Put the sonatype-work directory in the var directory, to persist across version updates
    inreplace "nexus-#{version}/conf/nexus.properties",
      "nexus-work=${bundleBasedir}/../sonatype-work/nexus",
      "nexus-work=#{var}/nexus"
    libexec.install Dir["nexus-#{version}/*"]
    bin.install_symlink libexec/"bin/nexus"
  end

  plist_options :manual => "nexus start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>com.sonatype.nexus</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/nexus</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
      <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    output = `#{bin}/nexus status`
    assert_match "Nexus OSS is", output
  end
end
