require "formula"

class Solr < Formula
  homepage "http://lucene.apache.org/solr/"
  url "http://www.apache.org/dyn/closer.cgi?path=lucene/solr/4.10.1/solr-4.10.1.tgz"
  sha1 "6033a9887bbfdd1d8ce1bdafce0d65975cf910d8"

  bottle do
    cellar :any
    sha1 "813b592ac2f8608e4495c6b79e1ecafd63e96421" => :mavericks
    sha1 "5059173bedf5a8a70102ac414c9a43e79ce3c265" => :mountain_lion
    sha1 "6c17714dd9ee85c8bebe8c00adf21219d9f3a804" => :lion
  end

  def install
    libexec.install Dir["*"]
    bin.install "#{libexec}/bin/solr"
    share.install "#{libexec}/bin/solr.in.sh"
    prefix.install "#{libexec}/example"
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
end
