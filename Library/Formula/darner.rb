require 'formula'

class Darner < Formula
  homepage 'https://github.com/wavii/darner'
  url 'https://github.com/wavii/darner/tarball/v0.1.4'
  sha1 '721e31ea843047536fb265eaca70ddc592d14f43'

  head 'https://github.com/wavii/darner.git'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'snappy'
  depends_on 'leveldb'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"

    # Create the data directory.
    FileUtils.mkdir_p "#{var}/darner/"

    # Create the log directory.
    FileUtils.mkdir_p "#{var}/log/darner/"
  end

  def caveats
    <<-EOS.undent
    If this is your first install, automatically load Darner on login with:
        mkdir -p ~/Library/LaunchAgents
        ln -nfs #{plist_path} ~/Library/LaunchAgents/
        launchctl load -wF ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        ln -nfs #{plist_path} ~/Library/LaunchAgents/
        launchctl load -wF ~/Library/LaunchAgents/#{plist_path.basename}

    To stop the Darner daemon:
        launchctl unload -wF ~/Library/LaunchAgents/#{plist_path.basename}

    You'll find the Darner log here:
        open #{var}/log/darner/darner.log

    To start Darner manually:
        darner -d #{var}/darner

    EOS
  end

  def startup_plist
    <<-PLIST.undent
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
            <string>#{HOMEBREW_PREFIX}/bin/darner</string>
            <string>-d</string>
            <string>#{var}/darner</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/darner/darner.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/darner/darner.log</string>
        </dict>
      </plist>
    PLIST
  end
end
