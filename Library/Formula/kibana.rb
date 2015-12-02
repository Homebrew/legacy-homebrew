class Kibana < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://download.elastic.co/kibana/kibana/kibana-4.3.0-darwin-x64.tar.gz"
  sha256 "b9952879be618b179275a0a0fb6ef9121f4f6d8784f70fb9aa059a05e3991c9d"
  version "4.3.0"
  head "https://github.com/elastic/kibana.git"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install Dir["*"]

    inreplace "#{prefix}/config/kibana.yml" do |s|
      s.sub!(%r{/var/run/kibana.pid}, "/usr/local/var/run/kibana.pid")
    end
    (etc/"kibana").install Dir[prefix/"config/kibana.yml"] unless (etc/"kibana/kibana.yml").exist?
  end

  def post_install
    ln_s etc/"kibana", prefix/"config"

    (var/"lib/kibana").mkpath
    rm_f var/"lib/kibana/node_modules"
    ln_s prefix/"node_modules", var/"lib/kibana/node_modules"

    (var/"lib/kibana/installedPlugins").mkpath
    ln_s var/"lib/kibana/installedPlugins", prefix/"installedPlugins"
  end

  plist_options :manual => "kibana"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/kibana</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    ENV["BABEL_CACHE_PATH"] = testpath/".babelcache.json"
    assert_match /#{version}/, shell_output("#{bin}/kibana -V")
  end
end
