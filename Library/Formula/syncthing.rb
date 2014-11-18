require "formula"

class Syncthing < Formula
  homepage "http://syncthing.net"
  url "https://github.com/syncthing/syncthing.git", :tag => "v0.10.6"

  bottle do
    sha1 "df6e7cd066084df00952c5dcfcda7f0b200ff0c9" => :yosemite
    sha1 "524818c844b07255095a71009b02873f213cb205" => :mavericks
    sha1 "4ad97cc63c34dec627819093f1629bf417d31aec" => :mountain_lion
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
        <key>EnvironmentVariables</key>
        <dict>
          <key>STNORESTART</key>
          <string>yes</string>
        </dict>
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
