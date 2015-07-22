require "language/go"

class SyncthingInotify < Formula
  desc "File watcher intended for use with Syncthing"
  homepage "https://github.com/syncthing/syncthing-inotify"
  url "https://github.com/syncthing/syncthing-inotify/archive/v0.6.5.tar.gz"
  sha256 "430297896bb05396268fd29cc555eba6542b42263489784c9843f4daf625ac5c"

  depends_on "go" => :build

  go_resource "github.com/cenkalti/backoff" do
    url "https://github.com/cenkalti/backoff.git",
        :revision => "6c45d6bc1e78d94431dff8fc28a99f20bafa355a" # not sure !
  end

  go_resource "github.com/zillode/notify" do
    url "https://github.com/Zillode/notify.git",
      :revision => "f06b1e3b795091f2e1414067b08e5f07332cdb05"   # not sure !
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV.append_path "PATH", buildpath
    bin_name = "syncthing-inotify"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin_name
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
    system "syncthing-inotify", "-version"
  end
end
