class Solr < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://lucene.apache.org/solr/"
  url "https://www.apache.org/dyn/closer.cgi?path=lucene/solr/5.4.0/solr-5.4.0.tgz"
  mirror "https://archive.apache.org/dist/lucene/solr/5.4.0/solr-5.4.0.tgz"
  sha256 "84c0f04a23047946f54618a092d4510d88d7205a756b948208de9e5afb42f7cd"

  bottle :unneeded

  depends_on :java

  skip_clean "example/logs"

  def install
    libexec.install Dir["*"]
    bin.install "#{libexec}/bin/solr"
    bin.install "#{libexec}/bin/post"
    bin.install "#{libexec}/bin/oom_solr.sh"
    share.install "#{libexec}/bin/solr.in.sh"
    prefix.install "#{libexec}/example"
    prefix.install "#{libexec}/server"

    # Fix the classpath for the post tool
    inreplace "#{bin}/post", '"$SOLR_TIP/dist"', "#{libexec}/dist"

    # Fix the paths in the sample solrconfig.xml files
    Dir.glob(["#{prefix}/example/**/solrconfig.xml",
      "#{prefix}/**/data_driven_schema_configs/**/solrconfig.xml",
      "#{prefix}/**/sample_techproducts_configs/**/solrconfig.xml"]) do |f|
      inreplace f, ":../../../..}/", "}/libexec/"
    end
  end

  plist_options :manual => "solr start"

  def plist; <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/solr</string>
            <string>start</string>
            <string>-f</string>
          </array>
          <key>ServiceDescription</key>
          <string>#{name}</string>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
          <key>RunAtLoad</key>
          <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    system bin/"solr"
  end
end
