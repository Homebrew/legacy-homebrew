# El Capitan & Homebrew

Part of the OS X 10.11/El Capitan changes is something called [System Integrity Protection](https://en.wikipedia.org/wiki/System_Integrity_Protection) or "SIP".

SIP prevents you from writing to many system directories such as `/usr`, `/System` & `/bin`, regardless of whether or not you are root. The Apple keynote is [here](https://developer.apple.com/videos/wwdc/2015/?id=706) if you'd like to learn more. As noted in the keynote, Apple is leaving `/usr/local` open for developers to use, so Homebrew can still be used as expected.

One of the implications of SIP was that you could not simply create `/usr/local` if you had removed it. This issue was fixed with the `com.apple.pkg.SystemIntegrityProtectionConfig.14U2076` update.

**If you haven't installed Homebrew in `/usr/local` or another system-protected directory, this document does not apply to you.**

This is how to fix Homebrew on El Capitan if you see permission issues:

## If `/usr/local` exists already:

```bash
sudo chown -R $(whoami):admin /usr/local
```

## If `/usr/local` does not exist:
First, try to create `/usr/local` the normal way:

```bash
  sudo mkdir /usr/local && sudo chflags norestricted /usr/local && sudo chown -R $(whoami):admin /usr/local
```

If you see permission issues instead try:

* Reboot into Recovery mode (Hold Cmd+R on boot) & access the Terminal.
* In that terminal run:
    `csrutil disable`
* Reboot back into OS X
* Open your Terminal application and execute:

```bash
  sudo mkdir /usr/local && sudo chflags norestricted /usr/local && sudo chown -R $(whoami):admin /usr/local
```

* Reboot back into Recovery Mode & access the Terminal again.
* In that terminal execute:
  `csrutil enable`
* Reboot back into OS X & you'll be able to write to `/usr/local` & install Homebrew.
