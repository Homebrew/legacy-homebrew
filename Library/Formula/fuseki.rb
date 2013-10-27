require 'formula'

class Fuseki < Formula
  homepage 'http://jena.apache.org/documentation/serving_data/'
  url "http://www.apache.org/dist/jena/binaries/jena-fuseki-1.0.0-distribution.tar.gz"
  version "1.0.0"
  sha1 '94349d9795a20cabb8b4f5887fc1b341b08cc271'

  def install
    # Remove windows files
    rm_f Dir["*.bat"]

    # Remove init.d script to avoid confusion
    rm 'fuseki'

    # Write the installation path into the wrapper shell script
    inreplace 'fuseki-server', /export FUSEKI_HOME=.+/, "export FUSEKI_HOME=\"#{prefix}\""
    inreplace 'fuseki-server', /^exec java\s+(.+)/, "exec java -Dlog4j.configuration=file:#{etc/'fuseki.log4j.properties'} \\1"

    # Use file logging instead of STDOUT logging
    (var/'log/fuseki').mkpath
    inreplace 'log4j.properties', /^log4j\.rootLogger=.+/, '### \0'
    inreplace 'log4j.properties', /^log4j\.appender\.stdlog.+/, '### \0'
    inreplace 'log4j.properties', /^## (log4j\.rootLogger=.+)/, '\1'
    inreplace 'log4j.properties', /^## (log4j\.appender\.FusekiFileLog.+)/, '\1'
    inreplace 'log4j.properties', /^log4j.appender.FusekiFileLog.File=.+/,
                                  "log4j.appender.FusekiFileLog.File=#{(var/'log/fuseki/fuseki.log')}"
    etc.install 'log4j.properties' => 'fuseki.log4j.properties'

    # Move binaries into place
    bin.install 'fuseki-server'
    bin.install Dir["s-*"]
    prefix.install 'fuseki-server.jar'

    unless File.exists?(etc/'fuseki.ttl')
      etc.cp 'config.ttl' => 'fuseki.ttl'
      ohai "The sample config.ttl config file has been copied to #{etc/'fuseki.ttl'}"
    end

    # Create a location for dataset files, in case we're being used in LaunchAgent mode
    (var/'fuseki').mkpath

    # Install example configs
    prefix.install Dir["config*.ttl"]

    # Install example data
    prefix.install 'Data'

    # Install documentation
    %w[DEPENDENCIES LICENSE NOTICE ReleaseNotes.txt pages].each do |docfile|
      prefix.install docfile
    end
  end

  def caveats; <<-EOS.undent
    Quick-start guide:

    * In-memory operation

      1. Start the server:
          fuseki-server --update --mem /ds

      2. Open webadmin:
          open http://localhost:3030/

      3. Import some sample data into the store:
          s-put http://localhost:3030/ds/data default #{prefix}/Data/books.ttl

    * LaunchAgent configuration

      1. Edit #{etc/'fuseki.ttl'} to configure your services and datasets
         (a directory #{var/'fuseki'} has been created for dataset folders)

      2. Follow the LaunchAgent instructions below

    Logging:

      Logging config is stored in #{etc/'fuseki.log4j.properties'}
      Currently this file will be overwritten if you re-install or upgrade Fuseki.

      To follow the logs, run:
        tail -f #{var/'log/fuseki/fuseki.log'}
    EOS
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/bin/fuseki-server</string>
          <string>--config</string>
          <string>/usr/local/etc/fuseki.ttl</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/fuseki-server", '--version'
  end
end
