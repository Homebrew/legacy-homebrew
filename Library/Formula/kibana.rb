class Kibana < Formula
  desc "Visualization tool for elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana/archive/v4.1.1.tar.gz"
  sha256 "3f91e99e20e82d4e84ec141007822fea8f9454c71595551f9348ea2609c98284"
  head "https://github.com/elastic/kibana.git"

  bottle do
    cellar :any
    sha256 "932177c7581bdeffceff3eca3019267cfcb334742e15ba6c0e6212d5efe100c0" => :yosemite
    sha256 "b8b741d84dddd27df01956fbd560f7025036e15c87639947904105912396a0f8" => :mavericks
    sha256 "a616da0b414e515cf895dcb278280e055dc7273d4cd38242dee597ec7d319100" => :mountain_lion
  end

  depends_on "node"

  def install
    ENV["HOME"] = buildpath/".brew_home"
    ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"

    system "npm", "install"
    system "npm", "install", "grunt-cli"
    system "npm", "install", "bower"
    system "./node_modules/.bin/bower", "install"
    system "./node_modules/.bin/grunt", "build", "--force"

    dist_dir = buildpath/"build/dist/kibana"

    rm_f dist_dir/"bin/*.bat"

    prefix.install dist_dir/"src"
    (etc/"kibana").mkpath
    (var/"lib/kibana/plugins").mkpath

    (etc/"kibana").install dist_dir/"config/kibana.yml" unless (etc/"kibana/kibana.yml").exist?

    # point to our node
    inreplace dist_dir/"bin/kibana" do |s|
      s.sub! /^NODE=.*$/, "NODE=#{Formula["node"].opt_bin}/node"
    end

    bin.install dist_dir/"bin/kibana"

    (prefix/"config").install_symlink etc/"kibana/kibana.yml"
    prefix.install_symlink var/"lib/kibana/plugins"
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
    assert_match /#{version}/, shell_output("#{bin}/kibana -V")
  end
end
