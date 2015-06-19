class Sonar < Formula
  desc "Manage code quality"
  homepage "http://www.sonarqube.org/"
  url "http://dist.sonar.codehaus.org/sonarqube-5.1.1.zip"
  sha256 "8626ff7b4eaf8aba92856b27ed0cdcea432d5596bd1ac167ec27cce70ad0557f"

  bottle do
    cellar :any
    sha256 "5f9746f44899ba83bb3f3fd519b52a0ed6016270e6c0e1b19a1c1c5b8e349fdd" => :yosemite
    sha256 "3b6dab1eee1a304a01ed3032b712d9425bf424c94bfcda4aef68f7a4e75483af" => :mavericks
    sha256 "564ac67dc416a49ee68473d820fb02712b011e24e2f125bf6304db56308f6814" => :mountain_lion
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
