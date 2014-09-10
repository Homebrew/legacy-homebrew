require "formula"

class Syncthing < Formula
  homepage "http://syncthing.net"
  url "https://github.com/calmh/syncthing.git", :tag => "v0.9.13"

  bottle do
    sha1 "b5a54fb570a3c7e09092f4f48268032d135dc7df" => :mavericks
    sha1 "8137213a3b091d43babc4963d6bc08839e1d3d05" => :mountain_lion
    sha1 "35534c1cad4219eef0a262c277833d3734803328" => :lion
  end

  depends_on "go" => :build
  depends_on :hg => :build

  def install
    ENV["GOPATH"] = cached_download/".gopath"
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"

    hack_dir = cached_download/".gopath/src/github.com/syncthing"
    rm_rf  hack_dir
    mkdir_p hack_dir
    ln_s cached_download, "#{hack_dir}/syncthing"
    ln_s cached_download/".git", ".git"

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
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/syncthing", "-generate", "./"
  end
end
