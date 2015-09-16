class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://jenkins-ci.org"
  url "http://mirrors.jenkins-ci.org/war/1.629/jenkins.war"
  sha256 "b74b1cd5b8873f0605106893e063dd2407afdcd1fd516e7034314385ac67605c"

  bottle do
    cellar :any_skip_relocation
    sha256 "3744a40461523f05f31ab332a4c507d3daff0cd53fe3426333bae7595a604e8e" => :el_capitan
    sha256 "c4367699fd865740124c4b1524a3e2412fad0e15d31c683eb3ac048b4b404367" => :yosemite
    sha256 "e7e54443f9767bef1b6deca5cc2288dae3e5c5b7571f23a9313143b6336e1151" => :mavericks
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
