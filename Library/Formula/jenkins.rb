require "formula"

class Jenkins < Formula
  homepage "https://jenkins-ci.org"
  url "http://mirrors.jenkins-ci.org/war/1.592/jenkins.war"
  sha1 "b90da7a24530f62e2f02f40f78fb145f2c1ce249"

  head "https://github.com/jenkinsci/jenkins.git"

  def install
    if build.head?
      system "mvn clean install -pl war -am -DskipTests"
      libexec.install "war/target/jenkins.war", "."
    else
      libexec.install "jenkins.war"
    end
    bin.write_jar_script libexec/"jenkins.war", "jenkins"
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
