require 'formula'

def kext_prefix
  prefix/'Library/Extensions'
end

class Tuntap < Formula
  homepage 'http://tuntaposx.sourceforge.net/'
  url 'git://git.code.sf.net/p/tuntaposx/code', :tag => 'release_20111101'
  version '20111101'

  def install
    ENV.j1 # to avoid race conditions (can't open: ../tuntap.o)
    cd 'tuntap' do
      system "make"
      kext_prefix.install "tun.kext", "tap.kext"
      prefix.install "startup_item/tap", "startup_item/tun"
    end
  end

  def caveats; <<-EOS.undent
      In order for TUN/TAP network devices to work, the tun/tap kernel extensions
      must be installed by the root user:

        sudo cp -pR #{kext_prefix}/tap.kext /Library/Extensions/
        sudo cp -pR #{kext_prefix}/tun.kext /Library/Extensions/
        sudo chown -R root:wheel /Library/Extensions/tap.kext
        sudo chown -R root:wheel /Library/Extensions/tun.kext
        sudo touch /Library/Extensions/

      To load the extensions at startup, you have to install those scripts too:

        sudo cp -pR #{prefix}/tap /Library/StartupItems/
        sudo chown -R root:wheel /Library/StartupItems/tap
        sudo cp -pR #{prefix}/tun /Library/StartupItems/
        sudo chown -R root:wheel /Library/StartupItems/tun

      If upgrading from a previous version of tuntap, the old kernel extension
      will need to be unloaded before performing the steps listed above. First,
      check that no tunnel is being activated, disconnect them all and then unload
      the kernel extension:

        sudo kextunload -b foo.tun
        sudo kextunload -b foo.tap

    EOS
  end
end
