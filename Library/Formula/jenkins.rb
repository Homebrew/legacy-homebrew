class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://jenkins-ci.org"
  url "http://mirrors.jenkins-ci.org/war/1.620/jenkins.war"
  sha256 "94f71bb1f08e73262ff40b412303b03558ba21ca106251d1ed1f77791f6ab728"

  bottle do
    cellar :any
    sha256 "55869fc506e1d5acfb3c49a44db76ada80494d707cc31d1c6528f30391dad0bf" => :yosemite
    sha256 "13fe085c8918efbae105e25e0e6cafee5f9c9c8bb76a9e3e9ba131f5c0e0e764" => :mavericks
    sha256 "ee046e888dd00c745b7d4cfe4c83a9051eae87ce379cb41aa2ca81742a21b32c" => :mountain_lion
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
