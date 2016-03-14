class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://jenkins-ci.org"
  url "http://mirrors.jenkins-ci.org/war/1.652/jenkins.war"
  sha256 "5d06f14d1035bc5eb6b77ebae90efc0f87de905ff04505dec30eea0eddd3ac27"

  devel do
    url "http://mirrors.jenkins-ci.org/war-rc/2.0/jenkins.war"
    version "2.0-rc"
    sha256 "7ff7759e1d7a097e018c8001db5f4248db04d0bf39f9b0f06934c124a936cfa2"
  end

  head do
    url "https://github.com/jenkinsci/jenkins.git"
    depends_on "maven" => :build
  end

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    if build.head?
      ENV.java_cache
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
    ENV["_JAVA_OPTIONS"] = "-Djava.io.tmpdir=#{testpath}"
    pid = fork do
      exec "#{bin}/jenkins"
    end
    sleep 60

    begin
      assert_match /Welcome to Jenkins!|Unlock Jenkins|Authentication required/, shell_output("curl localhost:8080/")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
