class Apcupsd < Formula
  desc "Daemon for controlling APC UPSes"
  homepage "http://www.apcupsd.org"
  url "https://downloads.sourceforge.net/project/apcupsd/apcupsd%20-%20Stable/3.14.13/apcupsd-3.14.13.tar.gz"
  sha256 "57ecbde01d0448bf8c4dbfe0ad016724ae66ab98adf2de955bf2be553c5d03f9"

  bottle do
    cellar :any
    sha256 "99759baac67d1133831cffcd7f3536064ee9b7dd521cd636aa7891239810011b" => :el_capitan
    sha256 "f69e0d86dbd74242d264618223d1f6aa893037fdf102bf4c0b82586f438376dd" => :yosemite
    sha256 "9396f5c9ba3788888b5f86e635bae2ec85d3f8d25a7de133dc781526c74d5a55" => :mavericks
  end

  depends_on "gd"
  depends_on "libusb-compat"

  def install
    # Paths below are hard-coded upstream for creation of `.pkg` installer.

    sysconfdir = etc/name

    cd "src/apcagent" do
      # Install apcagent.app to `prefix`.
      inreplace "Makefile", "Applications", prefix
    end

    cd "platforms/darwin" do
      # Fixes the `--sbindir` option.
      # Patch submitted to upstream repo:
      # https://sourceforge.net/p/apcupsd/mailman/message/34627459/
      inreplace "Makefile", "/sbin", "$(sbindir)"

      # Install launch daemon and kernel extension to subdirectories of `prefix`.
      inreplace "Makefile", "/Library/LaunchDaemons", "#{prefix}/Library/LaunchDaemons"
      inreplace "Makefile", "/System/Library/Extensions", kext_prefix

      # Use appropriate paths for launch daemon and launch script.
      inreplace "apcupsd-start", "/sbin", opt_sbin
      inreplace "apcupsd-start", "/etc/apcupsd", sysconfdir
      inreplace "org.apcupsd.apcupsd.plist", "/sbin", opt_sbin
      inreplace "org.apcupsd.apcupsd.plist", "/etc/apcupsd", sysconfdir

      # Custom uninstaller not needed as this is handled by Homebrew.
      inreplace "Makefile", /.*apcupsd-uninstall.*/, ""
    end

    system "./configure", "--prefix=#{prefix}",
                          "--sbindir=#{sbin}",
                          "--sysconfdir=#{sysconfdir}",
                          "--enable-cgi", "--with-cgi-bin=#{sysconfdir}",
                          "--enable-usb", "--enable-modbus-usb"

    system "make", "install"
  end

  def caveats
    s = <<-EOS.undent
      For #{name} to be able to communicate with UPSes connected via USB,
      the kernel extension must be installed by the root user:

        sudo cp -pR #{kext_prefix}/ApcupsdDummy.kext /System/Library/Extensions/
        sudo chown -R root:wheel /System/Library/Extensions/ApcupsdDummy.kext
        sudo touch /System/Library/Extensions/

    EOS

    if MacOS.version >= :el_capitan
      s += <<-EOS.undent
        Note: On OS X El Capitan and above, the kernel extension currently
        does not work as expected.

        You will have to unplug and plug the USB cable back in after each
        reboot in order for #{name} to be able to connect to the UPS.

      EOS
    end

    s += <<-EOS.undent
      To load #{name} at startup, activate the included Launch Daemon:

        sudo cp #{prefix}/Library/LaunchDaemons/org.apcupsd.apcupsd.plist /Library/LaunchDaemons
        sudo chmod 644 /Library/LaunchDaemons/org.apcupsd.apcupsd.plist
        sudo launchctl load -w /Library/LaunchDaemons/org.apcupsd.apcupsd.plist

      If this is an upgrade and you already have the Launch Daemon loaded, you
      have to unload the Launch Daemon before reinstalling it:

        sudo launchctl unload -w /Library/LaunchDaemons/org.apcupsd.apcupsd.plist
        sudo rm /Library/LaunchDaemons/org.apcupsd.apcupsd.plist
    EOS

    s
  end

  test do
    system "#{sbin}/apcupsd", "--version"
    assert_match /usage/, shell_output("#{sbin}/apctest --help", 1)
  end
end
