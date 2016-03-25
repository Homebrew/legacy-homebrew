class Offlineimap < Formula
  desc "Synchronizes emails between two repositories"
  homepage "http://offlineimap.org/"
  url "https://github.com/OfflineIMAP/offlineimap/archive/v6.7.0.tar.gz"
  sha256 "c446fb31bdca90c7db4146b918ad3fa05f6df5362a4cc961df6a7727a8aac210"
  head "https://github.com/OfflineIMAP/offlineimap.git"

  bottle :unneeded

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
