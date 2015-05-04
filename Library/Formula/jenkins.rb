class Jenkins < Formula
  homepage "https://jenkins-ci.org"
  url "http://mirrors.jenkins-ci.org/war/1.612/jenkins.war"
  sha256 "fc5f27870026b47565d010f6bb941fc5b5ffa115a6a5b56e301ccdf177ce83a9"

  bottle do
    cellar :any
    sha256 "f1d1d7387dbc590a20035ee098674063e1edc811743b707ce855843a0048ba0e" => :yosemite
    sha256 "852959cc1cfa024ccfd4030b74587c031e55d11c9874fe244513aca8a1a55a88" => :mavericks
    sha256 "65893e533fd704ec802104c789b8414c0e14036ef2b1247922da16d0e922ea48" => :mountain_lion
  end

  head do
    url "https://github.com/jenkinsci/jenkins.git"
    depends_on "maven" => :build
  end

  depends_on :java => "1.6+"

  def install
    if build.head?
      system "mvn", "clean", "install", "-pl", "war", "-am", "-DskipTests"
    else
      system "jar", "xvf", "jenkins.war"
    end
    libexec.install Dir["**/jenkins.war", "**/jenkins-cli.jar"]
    bin.write_jar_script libexec/"jenkins.war", "jenkins"
    bin.write_jar_script libexec/"jenkins-cli.jar", "jenkins-cli"
  end

  plist_options :manual => "jenkins"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>/usr/bin/java</string>
          <string>-Dmail.smtp.starttls.enable=true</string>
          <string>-jar</string>
          <string>#{opt_libexec}/jenkins.war</string>
          <string>--httpListenAddress=127.0.0.1</string>
          <string>--httpPort=8080</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  def caveats; <<-EOS.undent
    Note: When using launchctl the port will be 8080.
    EOS
  end
end
