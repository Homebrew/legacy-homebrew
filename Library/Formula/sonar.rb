class Sonar < Formula
  desc "Manage code quality"
  homepage "http://www.sonarqube.org/"
  url "http://dist.sonar.codehaus.org/sonarqube-5.1.2.zip"
  sha256 "a8d63d837242d0d07c0b3f65cfa9c84d5ae82ee51c6cbb52248bcf0d1bc58491"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb4adb0d9ff4ce176b1b6acd675b68ee2cad2e489da94df118acfb98ee912523" => :el_capitan
    sha256 "11fb73a3453a40950765be6bf38132b9aff0bdc8cc9b145769203af50b495187" => :yosemite
    sha256 "0adbea02c047442482e499970016459a02e9178e4372df64105092ce0e6c4455" => :mavericks
    sha256 "ae1b37b616b16a233a48913b872e26aa5345d5c8ef0daaa6cad4f4e2510eb16b" => :mountain_lion
  end

  def install
    # Delete native bin directories for other systems
    rm_rf Dir["bin/{aix,hpux,linux,solaris,windows}-*"]

    if MacOS.prefer_64_bit?
      rm_rf "bin/macosx-universal-32"
    else
      rm_rf "bin/macosx-universal-64"
    end

    # Delete Windows files
    rm_f Dir["war/*.bat"]
    libexec.install Dir["*"]

    if MacOS.prefer_64_bit?
      bin.install_symlink "#{libexec}/bin/macosx-universal-64/sonar.sh" => "sonar"
    else
      bin.install_symlink "#{libexec}/bin/macosx-universal-32/sonar.sh" => "sonar"
    end
  end

  plist_options :manual => "sonar console"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
        <string>#{opt_bin}/sonar</string>
        <string>start</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match /SonarQube/, shell_output("#{bin}/sonar status", 1)
  end
end
