require 'formula'

class Elasticsearch < Formula
  url 'https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.18.1.tar.gz'
  homepage 'http://www.elasticsearch.org'
  md5 '490c7959e02b885535e08e3cca2ffda8'

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

    # Install configuration files to 'etc' and symlink them from Cellar
    (etc+'elasticsearch').install prefix+'config/elasticsearch.yml'
    (etc+'elasticsearch').install prefix+'config/logging.yml'
    ln_s (etc+'elasticsearch/elasticsearch.yml'), (prefix+'config/elasticsearch.yml')
    ln_s (etc+'elasticsearch/logging.yml'),       (prefix+'config/logging.yml')

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

    See the 'elasticsearch.yml' file for overview of configuration options.

    Note that for development purposes, it usually makes sense
    to use small number of shards and no replicas.

    You may want to put something like this in the configuration file:
        index.number_of_shards: 1
        index.number_of_replicas: 0

    The ElasticSearch log is here:
        open #{var}/log/elasticsearch/#{cluster_name}.log

    And the folder with cluster data is here:
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
