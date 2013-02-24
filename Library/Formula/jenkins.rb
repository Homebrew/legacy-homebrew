require 'formula'

class Jenkins < Formula
  homepage 'http://jenkins-ci.org'
<<<<<<< HEAD
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

=======
  url 'http://mirrors.jenkins-ci.org/war/1.502/jenkins.war'
  sha1 '450b8bd2efb7cd3154681a767243ffd8807199bf'
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40
  head 'https://github.com/jenkinsci/jenkins.git'

  def install
    if build.head?
      system "mvn clean install -pl war -am -DskipTests"
      libexec.install 'war/target/jenkins.war', '.'
    else
      libexec.install "jenkins.war"
    end
  end

  plist_options :manual => "java -jar #{HOMEBREW_PREFIX}/opt/jenkins/libexec/jenkins.war"

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
          <string>-jar</string>
          <string>#{opt_prefix}/libexec/jenkins.war</string>
          <string>--httpListenAddress=127.0.0.1</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end
end
