class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "http://www.sonatype.org/"
  version "2.11.2-06"
  url "https://download.sonatype.com/nexus/oss/nexus-2.11.2-06-bundle.tar.gz"
  sha256 "e3fe7811d932ef449fafc4287a27fae62127154297d073f594ca5cba4721f59e"

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
