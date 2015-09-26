# El Capitan & Homebrew

Part of the OS X 10.11/El Capitan changes is something called [System Integrity Protection](https://en.wikipedia.org/wiki/System_Integrity_Protection) or "SIP".

SIP prevents you from writing to many system directories such as `/usr`, `/System` & `/bin`, regardless of whether or not you are root. The Apple keynote is [here](https://developer.apple.com/videos/wwdc/2015/?id=706) if you'd like to learn more.

One of the implications of SIP is that you cannot simply create `/usr/local` if it is removed or doesn't exist for another reason. However, as noted in the keynote, Apple is leaving `/usr/local` open for developers to use, so Homebrew can still be used as expected.

Apple documentation hints that `/usr/local` will be returned to `root:wheel restricted` permissions on [every OS X update](https://developer.apple.com/library/prerelease/mac/releasenotes/General/rn-osx-10.11/); Homebrew will be adding a `brew doctor` check to warn you when this happens in the near future.

If you haven't installed Homebrew in `/usr/local` or another system-protected directory, none of these concerns apply to you.

This is how to fix Homebrew on El Capitan if you see permission issues:

## If `/usr/local` exists already:

```bash
sudo chown $(whoami):admin /usr/local && sudo chown -R $(whoami):admin /usr/local
```

## If `/usr/local` does not exist:

* Reboot into Recovery mode (Hold Cmd+R on boot) & access the Terminal.
* In that terminal run:
    `csrutil disable`
* Reboot back into OS X
* Open your Terminal application and execute:

```bash
  sudo mkdir /usr/local && sudo chflags norestricted /usr/local && sudo chown $(whoami):admin /usr/local && sudo chown -R $(whoami):admin /usr/local
```

* Reboot back into Recovery Mode & access the Terminal again.
* In that terminal execute:
  `csrutil enable`
* Reboot back into OS X & you'll be able to write to `/usr/local` & install Homebrew.
