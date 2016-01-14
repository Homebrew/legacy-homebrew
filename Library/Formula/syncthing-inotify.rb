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
    sha256 "7dc11215aaa14312a14ef7c425e44598f5180ca86080d79f853818d441a8378c" => :el_capitan
    sha256 "0b0377da01a38af5cfc7b8c91af83b47fa87838a3e647ab3f67d1b6c06fa77a2" => :yosemite
    sha256 "dc103adff4ec6ef1c9d7d026187101c232154ca0a60352e9d6c6418fb48743f1" => :mavericks
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
