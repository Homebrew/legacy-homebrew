class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://jenkins-ci.org"
  url "http://mirrors.jenkins-ci.org/war/1.624/jenkins.war"
  sha256 "f8be718fe5ca3b025f53c89ddb484e1844995902816f739f93f5d2746e6db48a"

  bottle do
    cellar :any
    sha256 "449c298e7e578d33250bede3c858f56c4a30261d18d91ace0118d7073f01c245" => :yosemite
    sha256 "86cea889328370bcff786929d6adee9cdd8802e50274a6c2adef4a8babe5a9c5" => :mavericks
    sha256 "171f081796c5f4abb409fee0573ddd1e076bd8dd28269bed6c4c6683b53f3c44" => :mountain_lion
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
