require 'formula'

class Freeswitch < Formula
  homepage 'http://freeswitch.org'
  head 'git://git.freeswitch.org/freeswitch.git'
  url 'git://git.freeswitch.org/freeswitch.git', :tag => 'v1.0.6'
  version '1.0.6'

  depends_on 'jpeg'

  def install
    system "./bootstrap.sh -j#{ENV.make_jobs}"
    system "./configure", "--enable-shared", "--enable-static",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--exec_prefix=#{prefix}"

    system "make"
    system "make install"

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def test
    system "#{bin}/freeswitch -version"
  end

  def caveats; <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    Or start it manually:
        freeswitch -nc --nonat
    EOS
  end

  def startup_plist; <<-EOS.undent
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
          <string>#{bin}/freeswitch</string>
          <string>-nc</string>
          <string>-nonat</string>
        </array>
      <key>RunAtLoad</key>
        <true/>
      <key>ServiceIPC</key>
        <true/>
    </dict>
    </plist>
    EOS
  end
end
