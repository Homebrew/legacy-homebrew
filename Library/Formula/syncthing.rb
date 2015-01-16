class Syncthing < Formula
  homepage "http://syncthing.net"
  url "https://github.com/syncthing/syncthing.git", :tag => "v0.10.20"

  bottle do
    sha1 "c734cf769c576ea6a4d6dbcce43543633386f15f" => :yosemite
    sha1 "a5c3f2f2882c81acd87636a6301d17de926d47a1" => :mavericks
    sha1 "7a4dee0d17a1f5df6acb013c8f0d51d28160a415" => :mountain_lion
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
    ENV["GIT_DIR"] = cached_download/".git"

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
    system "#{bin}/syncthing", "-generate", "./"
  end
end
