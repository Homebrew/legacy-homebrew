Linuxbrew
=========

A fork of Homebrew for Linux

Install Linuxbrew (tl;dr)
-------------------------

Paste at a Terminal prompt:

``` sh
ruby -e "$(wget -O- https://raw.github.com/Homebrew/linuxbrew/go/install)"
```

See [Dependencies](#dependencies) and [Installation](#installation) below for more details.

Features
--------

+ Can install software to a home directory and so does not require sudo
+ Install software not packaged by the native distribution
+ Install up-to-date versions of software when the native distribution is old
+ Use the same package manager to manage both your Mac and Linux machines

Dependencies
------------

* **Ruby** 1.8.6 or newer
+ **GCC** 4.2 or newer

Paste at a Terminal prompt:

### Debian or Ubuntu

```sh
sudo apt-get install build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev
```

### Fedora

```sh
sudo yum groupinstall 'Development Tools' && sudo yum install curl git m4 ruby texinfo bzip2-devel curl-devel expat-devel ncurses-devel zlib-devel
```

Installation
------------

Paste at a Terminal prompt:

``` sh
ruby -e "$(wget -O- https://raw.github.com/Homebrew/linuxbrew/go/install)"
```

Or if you prefer:

```sh
git clone https://github.com/Homebrew/linuxbrew.git ~/.linuxbrew
```

Add to your `.bashrc` or `.zshrc`:

```sh
export PATH="$HOME/.linuxbrew/bin:$PATH"
```

You're done!

```sh
brew install $WHATEVER_YOU_WANT
```

What Packages Are Available?
----------------------------
1. You can [browse the Formula directory on GitHub][formula].
2. Or type `brew search` for a list.
3. Or visit [braumeister.org][braumeister] to browse packages online.
4. Or use [`brew desc`][brew-desc] to browse packages from the command line.

More Documentation
------------------
`brew help` or `man brew` or check our [wiki][].

Troubleshooting
---------------
First, please run `brew update` and `brew doctor`.

Second, read the [Troubleshooting Checklist](https://github.com/Homebrew/homebrew/wiki/troubleshooting).

**If you don't read these it will take us far longer to help you with your problem.**

Something broke!
----------------

Many of the Homebrew formulae work on either Mac or Linux without changes, but
some formulae will need to be adapted for Linux. If a formula doesn't work,
[open an issue on GitHub][issues] or, even better, submit a pull request.

[issues]: https://github.com/Homebrew/linuxbrew/issues

Who Are You?
------------
Linuxbrew is maintained by [Shaun Jackman][sjackman].

Homebrew's current maintainers are [Misty De Meo][mistydemeo], [Adam Vandenberg][adamv], [Jack Nagel][jacknagel], [Mike McQuaid][mikemcquaid] and [Brett Koonce][asparagui].

Homebrew was originally created by [Max Howell][mxcl].

License
-------
Code is under the [BSD 2 Clause (NetBSD) license][license].

Donations
---------
We accept tips through [Gittip][tip].

### Shaun Jackman

[![Gittip](https://img.shields.io/gittip/sjackman.svg?style=flat)](https://www.gittip.com/sjackman/)

### Homebrew

[![Gittip](https://img.shields.io/gittip/Homebrew.svg?style=flat)](https://www.gittip.com/Homebrew/)

[home]:http://brew.sh
[wiki]:https://github.com/Homebrew/homebrew/wiki
[mistydemeo]:https://github.com/mistydemeo
[adamv]:https://github.com/adamv
[jacknagel]:https://github.com/jacknagel
[mikemcquaid]:https://github.com/mikemcquaid
[asparagui]:https://github.com/asparagui
[sjackman]:https://github.com/sjackman
[mxcl]:https://github.com/mxcl
[formula]:https://github.com/Homebrew/homebrew/tree/master/Library/Formula/
[braumeister]:http://braumeister.org
[brew-desc]: https://github.com/telemachus/homebrew-desc
[license]:https://github.com/Homebrew/homebrew/tree/master/LICENSE.txt
[tip]:https://www.gittip.com/Homebrew/
