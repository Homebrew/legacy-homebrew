class Syncthing < Formula
  homepage "http://syncthing.net"
  url "https://github.com/syncthing/syncthing.git",
    :tag => "v0.10.27", :revision => "19e82e93b15ff0d9b95d2e8d2144d7c1d7be3c55"

  head "https://github.com/syncthing/syncthing.git"

  bottle do
    sha256 "10f502d51e4c475cb33807fd70301906c0b3589acb8dbfe2cc1e00b48793499f" => :yosemite
    sha256 "473bfddaaa4ff8f79de9ff0ee874cc749e793257f2a865021f912bb5e0363544" => :mavericks
    sha256 "f1ab377ff0cf3aa347a3ac70827906460000dc878da40e354ea59a1a1aa6c3eb" => :mountain_lion
  end

  depends_on "go" => :build
  depends_on :hg => :build

  def install
    ENV["GOPATH"] = cached_download/".gopath"
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"

    # FIXTHIS: do this without mutating the cache!
    hack_dir = cached_download/".gopath/src/github.com/syncthing"
    rm_rf hack_dir
    mkdir_p hack_dir
    ln_s cached_download, "#{hack_dir}/syncthing"

    system "./build.sh", "noupgrade"
    bin.install "syncthing"
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
          <string>#{opt_bin}/syncthing</string>
          <string>-no-browser</string>
          <string>-no-restart</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>ProcessType</key>
        <string>Background</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/syncthing.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/syncthing.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"syncthing", "-generate", "./"
  end
end
