require "formula"

class Syncthing < Formula
  homepage "http://syncthing.net"
  url "https://github.com/calmh/syncthing.git", :tag => "v0.9.14"

  bottle do
    revision 1
    sha1 "af25e4bf564d8574c13e020cc27593ed171d7ed3" => :mavericks
    sha1 "70188e5092754e382e4e9608d0644ec5b8f94718" => :mountain_lion
    sha1 "b62d6ae89fba4552871bf5204d9a4a74528248ec" => :lion
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
