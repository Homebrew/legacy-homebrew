class Kibana < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git", :tag => "v4.3.0", :revision => "e32749e1fa442853975ce2abd5ac2fd88a2dcf58"
  head "https://github.com/elastic/kibana.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a63101c190529aa0798ff7dabe7e7ee3fe8a6a04a126d324eb58fa8343e3a67d" => :el_capitan
    sha256 "f8768f21442e9ce85b3c9b3da58d8e73c176d7bf656b636d15ab582074f14991" => :yosemite
    sha256 "0bcea2ae726c5a175660c6350f4d60ee07a364d1574c90a2bd691ee25123afbb" => :mavericks
    sha256 "5d102f006b25dae70bd62c99d9787abe10111460bc2119e5e5ceb412d6335dae" => :mountain_lion
  end

  resource "node" do
    url "https://nodejs.org/dist/v0.12.7/node-v0.12.7.tar.gz"
    sha256 "b23d64df051c9c969b0c583f802d5d71de342e53067127a5061415be7e12f39d"
  end

  def install
    resource("node").stage buildpath/"node"
    cd buildpath/"node" do
      system "./configure", "--prefix=#{libexec}/node"
      system "make", "install"
    end

    # do not download binary installs of Node.js
    inreplace buildpath/"tasks/build/index.js" do |s|
      s.gsub!(%r{('_build:downloadNodeBuilds:\w+',)}, "// \\1")
    end

    # do not build packages for other platforms
    inreplace buildpath/"tasks/config/platforms.js" do |s|
      s.gsub!(%r{('(linux-x64|linux-x86|windows)',?(?!;))}, "// \\1")
    end

    ENV.prepend_path "PATH", prefix/"libexec/node/bin"
    system "npm", "install"
    system "npm", "run", "build"
    mkdir "tar"
    system "tar", "--strip-components", "1", "-xf", Dir["target/kibana-*-darwin-x64.tar.gz"].first, "-C", "tar"

    rm_f Dir["tar/bin/*.bat"]
    ["bin", "config", "node_modules", "optimize", "package.json", "src", "webpackShims"].each do |s|
      prefix.install "tar/#{s}"
      end
  end

  def post_install
    inreplace "#{bin}/kibana" do |s|
      s.sub!(%r{/node/bin/node}, "/libexec/node/bin/node")
    end
    inreplace "#{prefix}/config/kibana.yml" do |s|
      s.sub!(%r{/var/run/kibana.pid}, "/usr/local/var/run/kibana.pid")
    end
    (etc/"kibana").install prefix/"config/kibana.yml" unless (etc/"kibana/kibana.yml").exist?
    rm_rf prefix/"config"
    ln_s etc/"kibana", prefix/"config"

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
