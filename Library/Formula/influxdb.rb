require "formula"

class Influxdb < Formula
  homepage "http://influxdb.org"
  url "http://get.influxdb.org/influxdb-0.3.2.src.tar.gz"
  sha1 "6b730a75e6694abd5e913b4ad08936f7661569bd"

  devel do
    url "http://get.influxdb.org/influxdb-0.4.0.rc5.src.tar.gz"
    sha1 "b9f1bd55333060ce10691a2f68fdb35eda944bf7"
  end

  bottle do
    sha1 '9cc355279cf466f4ebc5704287c255c1d0312093' => :mavericks
    sha1 'ffb246bf0923ca28b31db256b259b95a96f81f80' => :mountain_lion
    sha1 '9f43d93ebfd3b8dd1c9d4d43f600d38504be2d66' => :lion
  end

  depends_on "leveldb"
  depends_on "protobuf" => :build
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    flex = Formula.factory('flex').bin/"flex"
    bison = Formula.factory('bison').bin/"bison"

    build_target = build.devel? ? "daemon" : "server"
    config_type = build.devel? ? "toml" : "json"

    system "./configure", "--with-flex=#{flex}", "--with-bison=#{bison}"
    system "make dependencies protobuf parser"
    system "go build #{build_target}"

    inreplace "config.#{config_type}.sample" do |s|
      s.gsub! "/tmp/influxdb/development/db", "#{var}/influxdb/data"
      s.gsub! "/tmp/influxdb/development/raft", "#{var}/influxdb/raft"
      s.gsub! "./admin", "#{opt_prefix}/share/admin"
    end

    bin.install build_target => "influxdb"
    etc.install "config.#{config_type}.sample" => "influxdb.conf"
    share.install "admin"

    (var/'influxdb/data').mkpath
    (var/'influxdb/raft').mkpath
  end

  plist_options :manual => "influxdb -config=#{HOMEBREW_PREFIX}/etc/influxdb.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/bin/influxdb</string>
          <string>-config=#{etc}/influxdb.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/influxdb.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/influxdb.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/influxdb -v"
  end
end
