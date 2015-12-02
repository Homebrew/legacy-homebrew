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
    inreplace buildpath/"tasks/build/index.js", %r{('_build:downloadNodeBuilds:\w+',)}, "// \\1"

    # do not build packages for other platforms
    platforms = Set.new(["darwin-x64", "linux-x64", "linux-x86", "windows"])
    if OS.mac? && Hardware::CPU.is_64_bit?
      platform = "darwin-x64"
    elsif OS.linux?
      platform = if Hardware::CPU.is_64_bit? then "linux-x64" else "linux-x86" end
    else
      raise "Installing Kibana via Homebrew is only supported on Darwin x86_64, Linux i386, Linux i686, and Linux x86_64"
    end
    platforms.delete(platform)
    sub = platforms.to_a.join("|")
    inreplace buildpath/"tasks/config/platforms.js", %r{('(#{sub})',?(?!;))}, "// \\1"

    # do not build zip package
    inreplace buildpath/"tasks/build/archives.js", %r{(await exec\('zip'.*)}, "// \\1"

    ENV.prepend_path "PATH", prefix/"libexec/node/bin"
    system "npm", "install"
    system "npm", "run", "build"
    mkdir "tar" do
      system "tar", "--strip-components", "1", "-xf", Dir[buildpath/"target/kibana-*-#{platform}.tar.gz"].first

      rm_f Dir["bin/*.bat"]
      prefix.install "bin", "config", "node_modules", "optimize", "package.json", "src", "webpackShims"
    end

    inreplace "#{bin}/kibana", %r{/node/bin/node}, "/libexec/node/bin/node"

    cd prefix do
      inreplace "config/kibana.yml", %{/var/run/kibana.pid}, var/"run/kibana.pid"
      (etc/"kibana").install Dir["config/*"]
      rm_rf "config"
    end
  end

  def post_install
    ln_s etc/"kibana", prefix/"config"

    (var/"lib/kibana/installedPlugins").mkpath
    ln_s var/"lib/kibana/installedPlugins", prefix/"installedPlugins"
  end

  plist_options :manual => "kibana"

  def caveats; <<-EOS.undent
    Plugins: #{var}/kibana/installedPlugins/
    Config: #{etc}/kibana/
    EOS
  end

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
