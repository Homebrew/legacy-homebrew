class Kibana < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git", :tag => "v4.4.1", :revision => "57474ae1b8647bccc5057792af7ab3f962f7521f"
  head "https://github.com/elastic/kibana.git"

  bottle do
    sha256 "f6fd5b4923cc1f8ca41ec27048c5ac4a13d379315a5920ee0e1a938d6489868d" => :el_capitan
    sha256 "f83fdee5a0218092c9592ee1c47aae4588d9cd49ab49946323a15c542c5d2f38" => :yosemite
    sha256 "234466f181d855643864d2bfd400226c4bde8c7a0976cabbfbfb878c9fe0115e" => :mavericks
  end

  resource "node" do
    url "https://nodejs.org/dist/v0.12.10/node-v0.12.10.tar.gz"
    sha256 "edbd3710512ec7518a3de4cabf9bfee6d12f278eef2e4b53422c7b063f6b976d"
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
    (prefix/"installedPlugins").mkdir
  end

  plist_options :manual => "kibana"

  def caveats; <<-EOS.undent
    Config: #{etc}/kibana/
    If you wish to preserve your plugins upon upgrade, make a copy of
    #{prefix}/installedPlugins before upgrading, and copy it into the
    new keg location after upgrading.
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
