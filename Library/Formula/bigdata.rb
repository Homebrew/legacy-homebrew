require "formula"

class Bigdata < Formula
  homepage "http://bigdata.com/blog/"
  url "http://bigdata.com/deploy/bigdata-1.3.0.tgz"
  sha1 "c22fa05df965019b3132161507ce0e77a4a1f6e2"

  def install
    prefix.install Dir["doc"]
    prefix.install Dir["var"]
    bin.install Dir["bin/*"]
    libexec.install Dir["lib/*"]

    # Set the installation path as the root for the bin scripts:
    inreplace "#{bin}/bigdata", "<%= BD_HOME %>", prefix
    inreplace "#{bin}/bigdata", "<%= INSTALL_TYPE %>", "BREW"

    # Set the Jetty root as the resourceBase in the jetty.xml file:
    inreplace "#{prefix}/var/jetty/etc/jetty.xml", "<%= JETTY_DIR %>", "#{prefix}/var/jetty"

    # Set the installation path as the root for bigdata.jnl file location (<bigdata_home>/data):
    inreplace "#{prefix}/var/jetty/WEB-INF/RWStore.properties", "<%= BD_HOME %>", prefix

    # Set the installation path as the root for log files (<bigdata_home>/log):
    inreplace "#{prefix}/var/jetty/WEB-INF/classes/log4j.properties", "<%= BD_HOME %>", prefix
  end

  def caveats; <<-EOS
     Congratulations! You have installed Bigdata!

     Usage: bigdata {start|stop|status|restart}

     After starting, visit: http://localhost:8080
    EOS
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
