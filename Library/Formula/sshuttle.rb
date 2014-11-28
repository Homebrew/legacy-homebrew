require 'formula'

class Sshuttle < Formula
  homepage 'https://github.com/apenwarr/sshuttle'
  url 'https://github.com/apenwarr/sshuttle/archive/sshuttle-0.61.tar.gz'
  sha1 '05551cdc78e866d983470ba4084beb206bacebd8'

  head 'https://github.com/apenwarr/sshuttle.git'

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    libexec.install Dir['*']
    bin.write_exec_script libexec/'sshuttle'
  end

  def caveats; <<-EOS.undent
    sshuttle will set net.inet.ip.scopedroute to 0 which
    will break break some things. Most notably,
    OS X Internet Sharing but it might might
    also affect other things (like other VPN clients).

    To undo this change, which sshuttle will apply automatically
    the first time you run it, you will need to manually edit
    /Library/Preferences/SystemConfiguration/com.apple.Boot.plist
    and reboot.
  EOS
  end
end
