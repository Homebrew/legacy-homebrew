require "language/go"

class SyncthingInotify < Formula
  desc "File watcher intended for use with Syncthing"
  homepage "https://github.com/syncthing/syncthing-inotify"
  url "https://github.com/syncthing/syncthing-inotify/archive/v0.6.7.tar.gz"
  sha256 "33f51b34906548fe69b4aab2dbbb24397b523b357d4c9137324c1fddda9022b0"

  head "https://github.com/syncthing/syncthing-inotify.git"

  bottle do
    cellar :any
    sha256 "30c9a5de4a72ccf8046aa58c70eb3d010575b675940c2251d34e3c1c01e28ff4" => :yosemite
    sha256 "0d15a5a3157c4afe71fcecad6fa4dae504abf183036863d8e65f470414010edb" => :mavericks
    sha256 "6ca9ddd5a10e9efd9c193abced9bbfc03e29c5305f6dd4b98ba0d1da3f6905cf" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/cenkalti/backoff" do
    url "https://github.com/cenkalti/backoff.git",
      :revision => "4dc77674aceaabba2c7e3da25d4c823edfb73f99" # not sure !
  end

  go_resource "github.com/zillode/notify" do
    url "https://github.com/Zillode/notify.git",
      :revision => "f06b1e3b795091f2e1414067b08e5f07332cdb05"   # not sure !
  end

  def install
    ENV["GOPATH"] = buildpath
    bin_name = "syncthing-inotify"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-ldflags", "-w -X main.Version #{version}", "-o", bin_name
    bin.install bin_name
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/syncthing-inotify</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>ProcessType</key>
        <string>Background</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/syncthing-inotify.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/syncthing-inotify.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"syncthing-inotify", "-version"
  end
end
