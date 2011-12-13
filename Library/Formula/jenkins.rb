require 'formula'

class Jenkins < Formula
  url 'http://mirrors.jenkins-ci.org/war/1.443/jenkins.war', :using => :nounzip
  head 'https://github.com/jenkinsci/jenkins.git'
  version '1.443'
  md5 'd004192da6c2061c11f7e6cd17603489'
  homepage 'http://jenkins-ci.org'

  def install
    system "mvn clean install -pl war -am -DskipTests && mv war/target/jenkins.war ." if ARGV.build_head?
    lib.install "jenkins.war"
    (prefix+'org.jenkins-ci.plist').write startup_plist
    (prefix+'org.jenkins-ci.plist').chmod 0644
  end

  def caveats; <<-EOS
If this is your first install, automatically load on login with:
    mkdir -p ~/Library/LaunchAgents
    cp #{prefix}/org.jenkins-ci.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/org.jenkins-ci.plist

If this is an upgrade and you already have the org.jenkins-ci.plist loaded:
    launchctl unload -w ~/Library/LaunchAgents/org.jenkins-ci.plist
    cp #{prefix}/org.jenkins-ci.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/org.jenkins-ci.plist

Or start it manually:
    java -jar #{lib}/jenkins.war
EOS
  end

  # There is a startup plist, as well as a runner, here and here:
  #  https://raw.github.com/jenkinsci/jenkins/master/osx/org.jenkins-ci.plist
  #  https://raw.github.com/jenkinsci/jenkins/master/osx/Library/Application%20Support/Jenkins/jenkins-runner.sh
  #
  # Perhaps they could be integrated.
  def startup_plist
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>Jenkins</string>
    <key>ProgramArguments</key>
    <array>
    <string>/usr/bin/java</string>
    <string>-jar</string>
    <string>#{lib}/jenkins.war</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOS
  end
end
