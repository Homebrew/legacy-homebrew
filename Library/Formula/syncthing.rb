class Syncthing < Formula
  homepage "http://syncthing.net"
  url "https://github.com/syncthing/syncthing.git",
    :tag => "v0.10.26", :revision => "9c3cee9ae4ff8ea7d8e3edc9eb7ff590a8255bdb"

  head "https://github.com/syncthing/syncthing.git"

  bottle do
    sha256 "ccde3860572a6c41902b37692ff9472d6c902e3ccf48191d9b0877f3f1b3f4da" => :yosemite
    sha256 "786522724164b5a1137397f195b571802f4bbbd06a01aff13cc4cbc47bc955b8" => :mavericks
    sha256 "7ede3d8431a012f3057d3e3d829acb88e009b78540e3e12a48b07f56af9d79af" => :mountain_lion
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
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"syncthing", "-generate", "./"
  end
end
