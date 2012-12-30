require 'formula'

class Elasticsearch < Formula
  homepage 'http://www.elasticsearch.org'
  url 'http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.2.tar.gz'
  sha1 '9bedb3638e4fc5a53e264aab3c5ff1a345f22bab'

  def cluster_name
    "elasticsearch_#{ENV['USER']}"
  end

  def install
    # Remove Windows files
    rm_f Dir["bin/*.bat"]

    # Move libraries to `libexec` directory
    libexec.install Dir['lib/*.jar']
    (libexec/'sigar').install Dir['lib/sigar/*.{jar,dylib}']

    # Install everything else into package directory
    prefix.install Dir['*']

    # Set up ElasticSearch for local development:
    inreplace "#{prefix}/config/elasticsearch.yml" do |s|
      # 1. Give the cluster a unique name
      s.gsub! /#\s*cluster\.name\: elasticsearch/, "cluster.name: #{cluster_name}"

      # 2. Configure paths
      s.sub! "# path.data: /path/to/data", "path.data: #{var}/elasticsearch/"
      s.sub! "# path.logs: /path/to/logs", "path.logs: #{var}/log/elasticsearch/"
      s.sub! "# path.plugins: /path/to/plugins", "path.plugins: #{var}/lib/elasticsearch/plugins"

      # 3. Bind to loopback IP for laptops roaming different networks
      s.gsub! /#\s*network\.host\: [^\n]+/, "network.host: 127.0.0.1"
    end

    inreplace "#{bin}/elasticsearch.in.sh" do |s|
      # Configure ES_HOME
      s.sub!  /#\!\/bin\/sh\n/, "#!/bin/sh\n\nES_HOME=#{prefix}"
      # Configure ES_CLASSPATH paths to use libexec instead of lib
      s.gsub! /ES_HOME\/lib\//, "ES_HOME/libexec/"
    end

    inreplace "#{bin}/plugin" do |s|
      # Add the proper ES_CLASSPATH configuration
      s.sub!  /SCRIPT="\$0"/, %Q|SCRIPT="$0"\nES_CLASSPATH=#{prefix}/libexec|
      # Replace paths to use libexec instead of lib
      s.gsub! /\$ES_HOME\/lib\//, "$ES_CLASSPATH/"
    end
  end

  def caveats; <<-EOS.undent
    Data:    #{var}/elasticsearch/#{cluster_name}/
    Logs:    #{var}/log/elasticsearch/#{cluster_name}.log
    Plugins: #{var}/lib/elasticsearch/plugins/
    EOS
  end

  plist_options :manual => "elasticsearch -f -D es.config=#{HOMEBREW_PREFIX}/opt/elasticsearch/config/elasticsearch.yml"

  def plist; <<-EOS.undent
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
    EOS
  end
end
