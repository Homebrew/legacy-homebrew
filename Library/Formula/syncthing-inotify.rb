require "language/go"

class SyncthingInotify < Formula
  desc "File watcher intended for use with Syncthing"
  homepage "https://github.com/syncthing/syncthing-inotify"
  url "https://github.com/syncthing/syncthing-inotify/archive/v0.6.7.tar.gz"
  sha256 "33f51b34906548fe69b4aab2dbbb24397b523b357d4c9137324c1fddda9022b0"
  revision 1

  head "https://github.com/syncthing/syncthing-inotify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "344e58eeef25bb5e4df938746e6cf3f9ccf884b34d0f787096a125e91691e1c6" => :el_capitan
    sha256 "9c9dc1b88337d004261df6b5e923a8ef67724e5b82abb4027dbd40c334899ea8" => :yosemite
    sha256 "42b69b5131ca24c3521833b35035c3dd8fe7efa54b143fc211e56dbfa9ffff00" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/cenkalti/backoff" do
    url "https://github.com/cenkalti/backoff.git",
      :revision => "4dc77674aceaabba2c7e3da25d4c823edfb73f99"
  end

  go_resource "github.com/zillode/notify" do
    url "https://github.com/Zillode/notify.git",
      :revision => "f06b1e3b795091f2e1414067b08e5f07332cdb05"
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
