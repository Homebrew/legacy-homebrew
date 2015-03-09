class Syncthing < Formula
  homepage "http://syncthing.net"
  url "https://github.com/syncthing/syncthing.git", :tag => "v0.10.25"

  bottle do
    sha256 "41e77b56738159536e55a9cbacfd4a9e170f9fc236947ea7f7b9907df0e95ac2" => :yosemite
    sha256 "0fbb7328362a659ff0031ef00a643b8e0b53c673d306daaad9f9fdad3402b278" => :mavericks
    sha256 "64965ffa1e76f5a5ff309b3d9a906ddd6fe5553d4f4dfcac50d0543c21b3479d" => :mountain_lion
  end

  depends_on "go" => :build
  depends_on :hg => :build

  def install
    ENV["GOPATH"] = cached_download/".gopath"
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"

    # FIXTHIS: do this without mutating the cache!
    hack_dir = cached_download/".gopath/src/github.com/syncthing"
    rm_rf  hack_dir
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
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"syncthing", "-generate", "./"
  end
end
