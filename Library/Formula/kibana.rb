class Kibana < Formula
  desc "Visualization tool for elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana/archive/v4.1.1.tar.gz"
  sha256 "3f91e99e20e82d4e84ec141007822fea8f9454c71595551f9348ea2609c98284"
  head "https://github.com/elastic/kibana.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a63101c190529aa0798ff7dabe7e7ee3fe8a6a04a126d324eb58fa8343e3a67d" => :el_capitan
    sha256 "f8768f21442e9ce85b3c9b3da58d8e73c176d7bf656b636d15ab582074f14991" => :yosemite
    sha256 "0bcea2ae726c5a175660c6350f4d60ee07a364d1574c90a2bd691ee25123afbb" => :mavericks
    sha256 "5d102f006b25dae70bd62c99d9787abe10111460bc2119e5e5ceb412d6335dae" => :mountain_lion
  end

  depends_on "node"

  def install
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
