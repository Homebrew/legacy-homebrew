require "formula"

class Elasticsearch < Formula
  homepage "http://www.elasticsearch.org"
  url "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.tar.gz"
  sha1 "e74d80d79269bb224153ad63b45f1cf7448f3398"

  head do
    url "https://github.com/elasticsearch/elasticsearch.git"
    depends_on "maven"
  end

  def cluster_name
    "elasticsearch_#{ENV['USER']}"
  end

  def install
    if build.head?
      # Build the package from source
      system "mvn clean package -DskipTests"
      # Extract the package to the current directory
      system "tar --strip 1 -xzf target/releases/elasticsearch-*.tar.gz"
    end

    # Remove Windows files
    rm_f Dir["bin/*.bat"]

    # Move libraries to `libexec` directory
    libexec.install Dir['lib/*.jar']
    (libexec/'sigar').install Dir['lib/sigar/*.{jar,dylib}']

    # Install everything else into package directory
    prefix.install Dir['*']

    # Remove unnecessary files
    rm_f Dir["#{lib}/sigar/*"]
    if build.head?
      rm_rf "#{prefix}/pom.xml"
      rm_rf "#{prefix}/src/"
      rm_rf "#{prefix}/target/"
    end

    # Set up Elasticsearch for local development:
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
      s.sub!  /SCRIPT="\$0"/, %Q|SCRIPT="$0"\nES_CLASSPATH=#{libexec}|
      # Replace paths to use libexec instead of lib
      s.gsub! /\$ES_HOME\/lib\//, "$ES_CLASSPATH/"
    end
  end

  def post_install
    # Make sure runtime directories exist
    (var/"elasticsearch/#{cluster_name}").mkpath
    (var/"log/elasticsearch").mkpath
    (var/"lib/elasticsearch/plugins").mkpath
  end

  def caveats; <<-EOS.undent
    Data:    #{var}/elasticsearch/#{cluster_name}/
    Logs:    #{var}/log/elasticsearch/#{cluster_name}.log
    Plugins: #{var}/lib/elasticsearch/plugins/

    ElasticSearch requires Java 7; you will need to install an appropriate JDK.
    EOS
  end

  plist_options :manual => "elasticsearch --config=#{HOMEBREW_PREFIX}/opt/elasticsearch/config/elasticsearch.yml"

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
            <string>--config=#{prefix}/config/elasticsearch.yml</string>
          </array>
          <key>EnvironmentVariables</key>
          <dict>
            <key>ES_JAVA_OPTS</key>
            <string>-Xss200000</string>
          </dict>
          <key>RunAtLoad</key>
          <true/>
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
