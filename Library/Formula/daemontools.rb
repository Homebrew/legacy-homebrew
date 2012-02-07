require 'formula'

class Daemontools < Formula
  homepage 'http://cr.yp.to/daemontools.html'
  url 'http://cr.yp.to/daemontools/daemontools-0.76.tar.gz'
  md5 '1871af2453d6e464034968a0fbcb2bfc'

  def patches
  end
  def install
    inreplace('daemontools-0.76/src/svscanboot.sh', '/service', "#{etc}/service")

    Dir.chdir "daemontools-0.76" do
      system "package/compile"
      bin.install Dir["command/*"]
    end

    (prefix+'to.yp.cr.daemontools.plist').write startup_plist
    (prefix+'to.yp.cr.daemontools.plist').chmod 0644
  end

  def caveats; <<-EOS.undent
    To launch daemontools on startup:
    * if this is your first install:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/to.yp.cr.daemontools.plist ~/Library/LaunchAgents
        launchctl load -w ~/Library/LaunchAgents/to.yp.cr.daemontools.plist

    * if this is an upgrade and you already have the to.yp.cr.daemontools.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/to.yp.cr.daemontools.plist
        cp #{prefix}/to.yp.cr.daemontools.plist ~/Library/LaunchAgents
        launchctl load -w ~/Library/LaunchAgents/to.yp.cr.daemontools.plist

    You may also want to edit the plist to edit the log locations. The default service location
    is #{etc}/service, which you can edit in the plist as well in #{bin}/svscanboot.

    Note that the default service and log directories have not been pre-created in order to keep your
    filesystem uncluttered in case you want something else.
    EOS
  end

  def startup_plist; <<-EOPLIST.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>to.yp.cr.daemontools</string>
          <key>ServiceDescription</key>
          <string>daemontools</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{bin}/svscanboot</string>
          </array>
          <key>OnDemand</key>
          <false/>
          <key>WorkingDirectory</key>
          <string>#{etc}/service</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/daemontools/error.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/daemontools/out.log</string>
        </dict>
      </plist>
    EOPLIST
  end
end

