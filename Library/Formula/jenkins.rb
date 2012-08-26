require 'formula'

class Jenkins < Formula
  homepage 'http://jenkins-ci.org'
<<<<<<< HEAD
<<<<<<< HEAD
  url 'http://mirrors.jenkins-ci.org/war/1.474/jenkins.war'
  version '1.474'
  sha1 'c016c1aabe5e44699d20a382df3a7886dfa86df6'
=======
  url 'http://mirrors.jenkins-ci.org/war/1.476/jenkins.war'
  version '1.476'
  sha1 '53c80bd2d746a19780ffc0dac3f143ffcd01f09f'
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
  url 'http://mirrors.jenkins-ci.org/war/1.478/jenkins.war'
  version '1.478'
  sha1 'e26a450b8e1cee543a9038b37a41b8d0e9b9b043'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

  head 'https://github.com/jenkinsci/jenkins.git'

  def install
    if ARGV.build_head?
      system "mvn clean install -pl war -am -DskipTests"
      mv 'war/target/jenkins.war', '.'
    end

    libexec.install "jenkins.war"
    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats; <<-EOS.undent
    If this is your first install, automatically load on login with:
      mkdir -p ~/Library/LaunchAgents
      cp #{plist_path} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
      launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
      cp #{plist_path} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    Or start it manually:
      java -jar #{libexec}/jenkins.war
    EOS
  end

  def startup_plist; <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>#{plist_name}</string>
  <key>ProgramArguments</key>
  <array>
  <string>/usr/bin/java</string>
  <string>-jar</string>
  <string>#{libexec}/jenkins.war</string>
  <string>--httpListenAddress=127.0.0.1</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOS
  end
end
