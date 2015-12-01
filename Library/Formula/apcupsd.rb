class Apcupsd < Formula
  desc "Daemon for controlling APC UPSes"
  homepage "http://www.apcupsd.org"
  url "https://downloads.sourceforge.net/project/apcupsd/apcupsd%20-%20Stable/3.14.13/apcupsd-3.14.13.tar.gz"
  sha256 "57ecbde01d0448bf8c4dbfe0ad016724ae66ab98adf2de955bf2be553c5d03f9"

  option "with-usb", "Build with support for USB UPSes."

  depends_on "gd"
  depends_on "libusb-compat"

  def install
    cd "src/apcagent" do
      # Install apcagent.app to `prefix` instead of /Applications.
      inreplace "Makefile", "Applications", "#{"#{prefix}".gsub(%r{/^\//}, "")}"
    end

    sysconfdir = "#{etc}/apcupsd"

    cd "platforms/darwin" do
      # Install binaries to `prefix`.
      # Patch submitted to upstream repo:
      #   https://sourceforge.net/p/apcupsd/mailman/message/34627459/
      inreplace "Makefile", "/sbin", "$(sbindir)"

      # Install the LaunchDaemon and kernel extension to `prefix`.
      inreplace "Makefile", "/Library/LaunchDaemons", "#{prefix}/Library/LaunchDaemons"
      inreplace "Makefile", "/System/Library/Extensions", kext_prefix

      # Tell the launch script and LaunchDaemon to use the appropriate sbin and config directories.
      inreplace "apcupsd-start", "/sbin", opt_sbin
      inreplace "apcupsd-start", "/etc/apcupsd", sysconfdir
      inreplace "org.apcupsd.apcupsd.plist", "/sbin", opt_sbin
      inreplace "org.apcupsd.apcupsd.plist", "/etc/apcupsd", sysconfdir

      # Custom uninstaller is not needed as everything is installed to `prefix`.
      inreplace "Makefile", /.*apcupsd-uninstall.*/, ""
    end

    args = [
      "--disable-option-checking",
      "--prefix=#{prefix}",
      "--sbindir=#{sbin}",
      "--sysconfdir=#{sysconfdir}",
      "--with-cgi-bin=#{sysconfdir}",
      "--enable-cgi",
    ]

    args << "--enable-usb" << "--enable-modbus-usb" if build.with? "usb"

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    s = <<-EOS.undent
      The #{name} configuration files are located here:
        #{etc}/apcupsd

    EOS

    if build.with? "usb"
      if MacOS.version >= :el_capitan
        s += <<-EOS.undent
          Note: On OS X El Capitan and above, System Integrity Protection (SIP)
          prevents the #{name} kernel extension from loading, which is needed
          to communicate with UPSes connected via USB.

          You will have to unplug and plug the USB cable back in after each
          reboot in order for #{name} to be able to connect to the UPS.

        EOS
      else
        s += <<-EOS.undent
          For #{name} to be able to communicate with UPSes connected via USB,
          the #{name} kernel extension must be installed by the root user:

            sudo cp -pR #{kext_prefix}/ApcupsdDummy.kext /System/Library/Extensions/
            sudo chown -R root:wheel /System/Library/Extensions/ApcupsdDummy.kext
            sudo touch /System/Library/Extensions/

        EOS
      end
    end

    s += <<-EOS.undent
      To load #{name} at startup, activate the included Launch Daemon:

        sudo cp #{prefix}/Library/LaunchDaemons/org.apcupsd.apcupsd.plist /Library/LaunchDaemons
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
