class Bigdata < Formula
  desc "Graph database supporting RDF data model, Sesame, and Blueprint APIs"
  homepage "https://www.blazegraph.com/bigdata"
  url "https://downloads.sourceforge.net/project/bigdata/bigdata/1.5.3/bigdata-bundled.jar"
  version "1.5.3"
  sha256 "d72a490a7e86ad96a85e26f52977675ac0f0621b8b02866ce29410796d70d552"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "bigdata-bundled.jar"
    bin.write_jar_script libexec/"bigdata-bundled.jar", "bigdata"
  end

  plist_options :startup => "true", :manual => "bigdata start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/bigdata</string>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{prefix}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    server = fork do
      exec bin/"bigdata"
    end
    sleep 5
    Process.kill("TERM", server)
    File.exist? "bigdata.jnl"
    File.exist? "rules.log"
  end
end
