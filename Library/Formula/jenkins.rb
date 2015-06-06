class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://jenkins-ci.org"
  url "http://mirrors.jenkins-ci.org/war/1.616/jenkins.war"
  sha256 "ea8ba42a575c56880c8837032d52137ba3ba6ad6c7efffcb24ae591dddaa0e5e"

  bottle do
    cellar :any
    sha256 "da2173dd61e5a2f8698243db17070771d7f505e7729c9526de5d8e75ffde89df" => :yosemite
    sha256 "d36d67b1039cac8aec4d943fe2bff578f3384c8a7f94a6dd3f138426bb8ba0e3" => :mavericks
    sha256 "5223d0598cd7f74e96f7aa1e8e210ff931b18b03514b57c8212fc162cb15fc87" => :mountain_lion
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
