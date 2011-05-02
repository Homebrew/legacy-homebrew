require 'formula'

class Elasticsearch < Formula
  url 'https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.16.0.tar.gz'
  homepage 'http://www.elasticsearch.com'
  md5 '5d719acd670d9ac3393d436c21bd0b58'

  def install
    # Remove Windows files
    rm_f Dir["bin/*.bat"]

    # Install everything directly into folder
    prefix.install Dir['*']

    # Make sure we have support folders in /usr/var
    %w( run data/elasticsearch log ).each { |path| (var+path).mkpath }

    # Put basic configuration into config file
    inreplace "#{prefix}/config/elasticsearch.yml" do |s|
      s << <<-EOS.undent
        cluster:
          name: elasticsearch

        path:
          logs: #{var}/log
          data: #{var}/data

        boostrap:
          mlockall: true
      EOS
    end

    # Write PLIST file for `launchd`
    (prefix+'org.elasticsearch.plist').write startup_plist
  end

  def caveats
    <<-EOS.undent
    If this is your first install, automatically load ElasticSearch on login with:
        mkdir -p ~/Library/LaunchAgents
        ln -nfs #{prefix}/org.elasticsearch.plist ~/Library/LaunchAgents/
        launchctl load -wF ~/Library/LaunchAgents/org.elasticsearch.plist

    If this is an upgrade and you already have the org.elasticsearch.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/org.elasticsearch.plist
        ln -nfs #{prefix}/org.elasticsearch.plist ~/Library/LaunchAgents/
        launchctl load -wF ~/Library/LaunchAgents/org.elasticsearch.plist

    To stop the ElasticSearch daemon:
        launchctl unload -wF ~/Library/LaunchAgents/org.elasticsearch.plist

    To start ElasticSearch manually:
        elasticsearch -f -D es.config=#{prefix}/config/elasticsearch.yml

    See the #{prefix}/config/elasticsearch.yml file for configuration.

    You'll find the ElasticSearch log here:
        #{var}/log/elasticsearch.log

    The folder with all the data is here:
        #{var}/data/elasticsearch

    You should see ElasticSearch running:
        open http://localhost:9200/

    EOS
  end

  def startup_plist
    <<-PLIST.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <true/>
          <key>Label</key>
          <string>org.elasticsearch</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{bin}/elasticsearch</string>
            <string>-f</string>
            <string>-D es.config=#{prefix}/config/elasticsearch.yml</string>
            <string>-p #{var}/run/elasticsearch.pid</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>UserName</key>
          <string>#{`whoami`.chomp}</string>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/elasticsearch.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/elasticsearch.log</string>
        </dict>
      </plist>
    PLIST
  end
end
