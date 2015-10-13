class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "http://www.sonatype.org/"
  url "https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-2.11.4-01-bundle.tar.gz"
  version "2.11.4-01"
  sha256 "2901d00c7a5c287d0ab51980b0ea8ad6a3db936e6a9bc7aea573ec4e2b516719"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b681196601ce846b1ecc47c1bbb9bb7dbd8374bc58e08c82ab9b2d9f75e8f34" => :el_capitan
    sha256 "d4d4491805a55babac9c576952c31d2d2c398a44f9553ea28126c424fce67872" => :yosemite
    sha256 "bf9690d1cd468fd6e0cb1ef8e471bfe91e5d9ea4eb369f3f028665b19e2d0fe9" => :mavericks
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
