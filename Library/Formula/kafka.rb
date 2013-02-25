require 'formula'

class Kafka < Formula
  homepage 'http://kafka.apache.org/'
  url 'http://mirror.nexcess.net/apache/incubator/kafka/kafka-0.7.2-incubating/kafka-0.7.2-incubating-src.tgz'
  sha1 '9a0569bfaad280d2814c0437809a30ab002598ab'

  def install
    system "sh sbt update"
    system "sh sbt package"

    inreplace 'config/server.properties' do |s|
      # Use brew paths.
      s.sub! /^(log\.dir=).*/, "\\1#{var/'db/kafka'}"

      # Use the default number of threads (= number of cores on machine) instead of 8.
      s.sub! /^(?=num\.threads=)/, '# '

      # Zookeeper is overkill for most people.
      s.sub! /^(enable\.zookeeper=)true/, '\\1false'
    end

    libexec.install Dir['*']
    bin.write_exec_script Dir[libexec/'bin/*']
  end

  def plist_manual
    "kafka-server-start.sh #{libexec}/config/server.properties"
  end

  def plist
    <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{bin}/kafka-server-start.sh</string>
          <string>#{libexec}/config/server.properties</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>UserName</key>
        <string>#{ENV['USER']}</string>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
      </plist>
    EOS
  end
end
