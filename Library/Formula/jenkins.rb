class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://jenkins-ci.org"
  url "http://mirrors.jenkins-ci.org/war/1.622/jenkins.war"
  sha256 "e219546e9db0bdf913ceee04ab3f79fcbbb27ac7ca27619d184b82f93457b899"

  bottle do
    cellar :any
    sha256 "dfcbc53fd68537da7975209ed8adee8887e0fd106c86a44823defbc580ba1ca4" => :yosemite
    sha256 "74c689f2e749b3ac26b8a4cf4631649d0565696b10aa430e1168f3fc5a60917b" => :mavericks
    sha256 "356c460681bb460d3f4cdb89b86446b4c899db6cf6cdf5018a448fb86e266b96" => :mountain_lion
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
