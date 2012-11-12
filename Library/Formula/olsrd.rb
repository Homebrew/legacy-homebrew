require 'formula'

class Olsrd < Formula
  homepage 'http://www.olsr.org'
  url 'http://www.olsr.org/releases/0.6/olsrd-0.6.4.tar.bz2'
  sha1 '9a21400e7a97c685283a4e19850b88ada32bfd9c'

  def install
    custom_vars = %W[DESTDIR=#{prefix} USRDIR=#{prefix} LIBDIR=#{lib}]
    # running make install without build_all will fail
    system "make", "build_all", *custom_vars
    lib.mkpath
    system "make", "install_all", *custom_vars
  end

  def test
    File.executable?("#{sbin}/olsrd")
    File.file?("#{etc}/olsrd.conf")
    # Not needed for running, but helpful nevertheless
    File.file?("#{man8}/olsrd.8.gz")
    File.file?("#{man5}/olsrd.conf.5.gz")
    plugins = Dir.glob("#{lib}/*.so.*")
    plugins.count > 0
  end

  def caveats; <<-EOS.undent
    To configure olsrd, edit #{etc}/olsrd.conf to taste.

    To run it directly: olsrd -f #{etc}/olsrd.conf

    To load olsrd automatically on startup, install and load the provided launchd
    item as follows:

      sudo cp #{plist_path} /Library/LaunchDaemons
      sudo launchctl load -w /Library/LaunchDaemons/#{plist_path.basename}
    EOS
  end

  def startup_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{HOMEBREW_PREFIX}/sbin/olsrd</string>
          <string>-f</string>
          <string>#{etc}/olsrd.conf</string>
        </array>
        <key>KeepAlive</key>
        <dict>
          <key>NetworkState</key>
          <true/>
        </dict>
      </dict>
    </plist>
    EOS
  end
end
