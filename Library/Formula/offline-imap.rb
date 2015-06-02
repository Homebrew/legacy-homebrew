class OfflineImap < Formula
  homepage "http://offlineimap.org/"
  url "https://github.com/OfflineIMAP/offlineimap/archive/v6.5.7.tar.gz"
  sha256 "b7de52c7d8995e0657bb55da13531c8d6f96d828217159477c685ae408e390a3"

  head "https://github.com/OfflineIMAP/offlineimap.git"

  bottle do
    cellar :any
    sha256 "66181d527266669fb42a76a39bbf588238c4e3102270697da99ee4d13a579248" => :yosemite
    sha256 "30b28f478b8ae787ee30fd615a1b30d29911c0ebe34e27a5a832b2f3bf2f036c" => :mavericks
    sha256 "d5b18881b8ce16cfbe3b0ba78a2fb5cb66af38ce8d5a60961423ef6dc0eacd01" => :mountain_lion
  end

  def install
    etc.install "offlineimap.conf", "offlineimap.conf.minimal"
    libexec.install "bin/offlineimap" => "offlineimap.py"
    libexec.install "offlineimap"
    bin.install_symlink libexec+"offlineimap.py" => "offlineimap"
  end

  def caveats; <<-EOS.undent
    To get started, copy one of these configurations to ~/.offlineimaprc:
    * minimal configuration:
        cp -n #{etc}/offlineimap.conf.minimal ~/.offlineimaprc

    * advanced configuration:
        cp -n #{etc}/offlineimap.conf ~/.offlineimaprc
    EOS
  end

  test do
    system bin/"offlineimap", "--version"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/offlineimap</string>
        </array>
        <key>StartInterval</key>
        <integer>300</integer>
        <key>RunAtLoad</key>
        <true />
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end
end
