require 'formula'

class Aiccu < Formula
  homepage 'http://www.sixxs.net/tools/aiccu/'
  url 'http://www.sixxs.net/archive/sixxs/aiccu/unix/aiccu_20070115.tar.gz'
  md5 'c9bcc83644ed788e22a7c3f3d4021350'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "DESTDIR", prefix
      s.change_make_var! "dirsbin", "/sbin/"
      s.change_make_var! "dirbin", "/bin/"
      s.change_make_var! "diretc", "/etc/"
      s.change_make_var! "dirdoc", "/share/doc/aiccu/"
    end

    # make some dirs
    doc.mkpath
    man.mkpath

    # build and install
    system "make"
    system "make install"

    # copy the some files to the right place
    doc.install 'doc/aiccu.conf'
    man1.install 'doc/aiccu.1'

    # Write the launchd script
    plist_path.write startup_plist
    plist_path.chmod 0644

    # remove some useless init scripts
    rm_rf prefix+'etc/init.d'
  end

  def caveats; <<-EOS.undent
    You may also wish to install tuntap:

        The TunTap project provides kernel extensions for Mac OS X that allow
        creation of virtual network interfaces.

        http://tuntaposx.sourceforge.net/

    Because these are kernel extensions, there is no Homebrew formula for tuntap.


    For AICCU to work as a server, you will need to do the following:

    1) Create configuration file in #{etc}/aiccu.conf, samples can be
       found in #{share}/doc/aiccu.conf

    2) Install the launchd item in /Library/LaunchDaemons, like so:

       sudo cp -vf #{plist_path} /Library/LaunchDaemons/.
       sudo chown -v root:wheel /Library/LaunchDaemons/#{plist_path.basename}

    3) Start the daemon using:

       sudo launchctl load /Library/LaunchDaemons/#{plist_path.basename}

    Next boot of system will automatically start AICCU.
    EOS
  end

  def startup_plist
    return <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{HOMEBREW_PREFIX}/usr/sbin/aiccu</string>
          <string>start</string>
          <string>#{etc}/aiccu.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

end
