class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://jenkins-ci.org"
  url "http://mirrors.jenkins-ci.org/war/1.617/jenkins.war"
  sha256 "8d6e30c338a54d3eeb6deea6614dae8fba9e1a2a2d9bc7ce3c61604140f3aa3e"

  bottle do
    cellar :any
    sha256 "0d4325447bfaec2076de6a5fd07dea30b8817eb9dcfef848e13f540d796be931" => :yosemite
    sha256 "c1298d2baeb6d0b0748422a5c1ec0901f988c161577cfd7783df1a9d005da682" => :mavericks
    sha256 "e1d8e84efc9456867651c5d7c729365f4cbcd08c271e665c331c637c016298ce" => :mountain_lion
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
