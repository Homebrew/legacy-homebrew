require "formula"

class Bigdata < Formula
  homepage "http://bigdata.com/"
  url "http://bigdata.com/deploy/bigdata-1.3.1.tgz"
  sha1 "bcfacd08b1e1c7429d3ca31b8632a20cdff1fb79"

  def install
    prefix.install "doc", "var", "bin"
    libexec.install Dir["lib/*.jar"]

    File.rename "#{bin}/bigdataNSS", "#{bin}/bigdata"

    # Set the installation path as the root for the bin scripts:
    inreplace "#{bin}/bigdata" do |s|
      s.sub! "<%= BD_HOME %>", prefix
      s.sub! "<%= INSTALL_TYPE %>", "BREW"
    end

    # Set the installation path as the root for bigdata.jnl file location (<bigdata_home>/data):
    inreplace "#{prefix}/var/jetty/WEB-INF/RWStore.properties", "<%= BD_HOME %>", prefix

    # Set the installation path as the root for log files (<bigdata_home>/log):
    inreplace "#{prefix}/var/jetty/WEB-INF/classes/log4j.properties", "<%= BD_HOME %>", prefix
  end

  plist_options :startup => 'true', :manual => 'bigdata start'

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{bin}/bigdata</string>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{prefix}</string>
      </dict>
    </plist>
    EOS
  end

end
