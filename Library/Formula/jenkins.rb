class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://jenkins-ci.org"
  url "http://mirrors.jenkins-ci.org/war/1.626/jenkins.war"
  sha256 "e6df4d44f1110d1095b4e05c0d574f1120ac4f7bf943fba99c22edff0127c110"

  bottle do
    cellar :any
    sha256 "27b888de2255abfbec3438d304e7c3e5ea3c3c98d50775b7b4456d505730bfd4" => :yosemite
    sha256 "d1329ac5ed0f8afadcc6e651d7fe8dbbab46aa4aa8b54cc184f5c2abb8afa4ff" => :mavericks
    sha256 "a28c12de6ef20c1aaf4799b11676bd3d1dd00f6f0557a29d3072898a0cf6edc9" => :mountain_lion
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

  test do
    ENV["JENKINS_HOME"] = testpath
    pid = fork do
      exec "#{bin}/jenkins"
    end
    sleep 60

    begin
      assert_match /"mode":"NORMAL"/, shell_output("curl localhost:8080/api/json")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
