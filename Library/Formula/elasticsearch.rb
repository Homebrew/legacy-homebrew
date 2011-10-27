require 'formula'

class Elasticsearch < Formula
  url 'https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.17.9.tar.gz'
  homepage 'http://www.elasticsearch.org'
  md5 'be59eaf874280e8f748269531dd0cf07'

  def cluster_name
    "elasticsearch_#{ENV['USER']}"
  end

  def install
    # Remove Windows files
    rm_f Dir["bin/*.bat"]

    # Install everything directly into folder
    prefix.install Dir['*']

    # Set up ElasticSearch for local development:
    inreplace "#{prefix}/config/elasticsearch.yml" do |s|

      # 1. Give the cluster a unique name
      s.gsub! /#\s*cluster\.name\: elasticsearch/, "cluster.name: #{cluster_name}"

      # 2. Configure paths
      s.gsub! /#\s*path\.data\: [^\n]+/, "path.data: #{var}/elasticsearch/"
      s.gsub! /#\s*path\.logs\: [^\n]+/, "path.logs: #{var}/log/elasticsearch/"
    end

    # Write .plist file for `launchd`
    (prefix+'org.elasticsearch.plist').write startup_plist
    (prefix+'org.elasticsearch.plist').chmod 0644
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

    See the 'elasticsearch.yml' file for configuration options.

    You'll find the ElasticSearch log here:
        open #{var}/log/elasticsearch/#{cluster_name}.log

    The folder with cluster data is here:
        open #{var}/elasticsearch/#{cluster_name}/

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
    PLIST
  end
end
