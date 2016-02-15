require "language/go"

class SyncthingInotify < Formula
  desc "File watcher intended for use with Syncthing"
  homepage "https://github.com/syncthing/syncthing-inotify"
  url "https://github.com/syncthing/syncthing-inotify/archive/v0.6.8.tar.gz"
  sha256 "14e0684e51c40d5b62d0faef9a59e3a7c6a2ad97583cfbcdbc1684ffac5e3b7b"

  head "https://github.com/syncthing/syncthing-inotify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2c0a33dceee99bf0e7a3902b2a9b9a0f43a99f94c2c3e57c6c326bd6bd0661b" => :el_capitan
    sha256 "ac5c17fd02da576b0006bff8dba8badff7c057ab78e4d11751686736441c6ce7" => :yosemite
    sha256 "0befaf1bae9111d89f9862a6a44256b311ed09aeedfdf1d616273d03ea9674d6" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/cenkalti/backoff" do
    url "https://github.com/cenkalti/backoff.git",
      :revision => "4dc77674aceaabba2c7e3da25d4c823edfb73f99"
  end

  go_resource "github.com/zillode/notify" do
    url "https://github.com/Zillode/notify.git",
      :revision => "7a61ff497e40ce25d1c49bfe8402fdfb3be6a88c"
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
