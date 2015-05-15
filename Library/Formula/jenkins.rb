class Jenkins < Formula
  homepage "https://jenkins-ci.org"
  url "http://mirrors.jenkins-ci.org/war/1.613/jenkins.war"
  sha256 "1e3f9b095c49c22e91e0f1843a7e7d170387388338a13aed3cd4f77ea50aa47f"

  bottle do
    cellar :any
    sha256 "79c3028e1b7c1b683dd551c20766adf9586bc0627789419bbfeccd53306b9e6e" => :yosemite
    sha256 "db47b6b218255ff467ac2b8121abf4f66584a974e29585dc33332ccf747f7aa5" => :mavericks
    sha256 "429ae932f90fa85180853e7700bc5f8223e44a1ba27f4dbd268ba3b8596d686d" => :mountain_lion
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
