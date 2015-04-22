class Syncthing < Formula
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing.git",
    :tag => "v0.11.0", :revision => "b35958d024175609a9e07934cdb1bedd3243939c"

  head "https://github.com/syncthing/syncthing.git"

  bottle do
    sha256 "b2f6ac64a11e19dfddd6f78466050e3d2e0ae977dad51a98c71f1a16326f51f5" => :yosemite
    sha256 "ee5447e5933cf974e1e33f98c2058f88851921f81975437cab391f60f09b4e39" => :mavericks
    sha256 "0772de41191b2d666a5473fac4796ae9ecd66ec60f636b4b2661bb3b6da0398f" => :mountain_lion
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

  def caveats; <<-EOS.undent
    Syncthing v0.11.0 does not support synchronizing with older
    versions (v0.10 or older)

    You will need to manually upgrade all the nodes connecting 
    to this one.

    Please read the release notes for Syncthing 0.11.0:
      https://forum.syncthing.net/t/syncthing-v0-11-0-release-notes/2426
    EOS
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
