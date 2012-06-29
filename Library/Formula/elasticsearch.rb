require 'formula'

class Elasticsearch < Formula
  homepage 'http://www.elasticsearch.org'
  url 'https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.19.7.tar.gz'
  md5 '2d4f6d608862c47963483a1d7fa6e8c6'

  def cluster_name
    "elasticsearch_#{ENV['USER']}"
  end

  def install
    # Remove Windows files
    rm_f Dir["bin/*.bat"]
    # Move JARs from lib to libexec according to homebrew conventions
    libexec.install Dir['lib/*.jar']
    (libexec+'sigar').install Dir['lib/sigar/*.jar']

    # Install everything directly into folder
    prefix.install Dir['*']

    # Set up ElasticSearch for local development:
    inreplace "#{prefix}/config/elasticsearch.yml" do |s|

      # 1. Give the cluster a unique name
      s.gsub! /#\s*cluster\.name\: elasticsearch/, "cluster.name: #{cluster_name}"

      # 2. Configure paths
      s.gsub! /#\s*path\.data\: [^\n]+/, "path.data: #{var}/elasticsearch/"
      s.gsub! /#\s*path\.logs\: [^\n]+/, "path.logs: #{var}/log/elasticsearch/"

      # 3. Bind to loopback IP for laptops roaming different networks
      s.gsub! /#\s*network\.host\: [^\n]+/, "network.host: 127.0.0.1"
    end

    inreplace "#{bin}/elasticsearch.in.sh" do |s|
      # Replace CLASSPATH paths to use libexec instead of lib
      s.gsub! /ES_HOME\/lib\//, "ES_HOME/libexec/"
    end

    inreplace "#{bin}/elasticsearch" do |s|
      # Set ES_HOME to prefix value
      s.gsub! /^ES_HOME=.*$/, "ES_HOME=#{prefix}"
    end

    inreplace "#{bin}/plugin" do |s|
      # Set ES_HOME to prefix value
      s.gsub! /^ES_HOME=.*$/, "ES_HOME=#{prefix}"
      # Replace CLASSPATH paths to use libexec instead of lib
      s.gsub! /-cp \".*\"/, '-cp "$ES_HOME/libexec/*"'
    end

    # Write .plist file for `launchd`
    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats
    <<-EOS.undent
    If this is your first install, automatically load ElasticSearch on login with:
        mkdir -p ~/Library/LaunchAgents
        ln -nfs #{plist_path} ~/Library/LaunchAgents/
        launchctl load -wF ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        ln -nfs #{plist_path} ~/Library/LaunchAgents/
        launchctl load -wF ~/Library/LaunchAgents/#{plist_path.basename}

    If upgrading from 0.18 ElasticSearch requires flushing before shutting
    down the cluster with no indexing operations happening after flush:
        curl host:9200/_flush

    To stop the ElasticSearch daemon:
        launchctl unload -wF ~/Library/LaunchAgents/#{plist_path.basename}

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
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{HOMEBREW_PREFIX}/bin/elasticsearch</string>
            <string>-f</string>
            <string>-D es.config=#{prefix}/config/elasticsearch.yml</string>
          </array>
          <key>EnvironmentVariables</key>
          <dict>
            <key>ES_JAVA_OPTS</key>
            <string>-Xss200000</string>
          </dict>
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
