# Installation
The suggested and easiest way to install Homebrew is on the
[homepage](http://brew.sh).

The standard script installs Homebrew to `/usr/local` so that
[you don’t need sudo](FAQ.md#why-does-homebrew-say-sudo-is-bad-) when you `brew install`. It is a
careful script, it can be run even if you have stuff installed to
`/usr/local` already. It tells you exactly what it will do before it
does it too. And you have to confirm everything it will do before it
starts.

There are other ways to install Homebrew which provide you with more
flexibility. They are listed below the requirements.

## Requirements
* An Intel CPU <sup>[1](#1)</sup>
* OS X 10.6 or higher <sup>[2](#2)</sup>
* Command Line Tools for Xcode: `xcode-select --install`,
  https://developer.apple.com/downloads or
  [Xcode](https://itunes.apple.com/us/app/xcode/id497799835) <sup>[3](#3)</sup>
* A Bourne-compatible shell for installation (e.g. bash or zsh) <sup>[4](#4)</sup>

If you want to build software that utilizes X11 components, you’ll need
to install [XQuartz](https://xquartz.macosforge.org). Apple provided a
distribution of XQuartz (“X11.app”) prior to OS X 10.8. This is
supported where possible, but many projects now require more up-to-date
libraries than those in the Apple distribution, so installing the
[latest version available for your
OS](https://xquartz.macosforge.org/trac/wiki/Releases) is recommended.
On 10.8 and newer, you should install the [most recent
version](https://xquartz.macosforge.org).

If you want to build Java bindings (in software such as Subversion,
Berkeley-DB, CMake, etc.) Apple’s “Java Developer Update” is required.
The latest versions are “Update 10” for 10.5 and “Update 9” for 10.6.

## Alternative Installs
### Untar anywhere
Just extract (or `git clone`) Homebrew wherever you want. Just
avoid:

* Directories with names that contain spaces. Homebrew itself can handle spaces, but many build scripts cannot.
* `/sw` and `/opt/local` because build scripts get confused when
Homebrew is there instead of Fink or MacPorts, respectively.

However do yourself a favor and install to `/usr/local`. Some things may
not build when installed elsewhere. One of the reasons Homebrew just
works relative to the competition is **because** we recommend installing
to `/usr/local`. *Pick another prefix at your peril!*

`mkdir homebrew && curl -L https://github.com/Homebrew/homebrew/tarball/master | tar xz --strip 1 -C homebrew`

### Untar anywhere and then symlink the `brew` command elsewhere
You can also install Homebrew into e.g.
`~/Developer` and then symlink the brew command into `/usr/local/bin`.

Everything will install into `~/Developer`, but your
brew command is still in the path. **NOTE** that Homebrew will still
need to create symlinks into `/usr/local` or nothing will
work! But the actual files are installed to
`~/Developer/Cellar`.

### Multiple installations
Create a Homebrew installation wherever you extract the tarball. Whichever brew command is called is where the packages will be installed. You can use this as you see fit, e.g. a system set of libs in `/usr/local` and tweaked formulae for development in `~/homebrew`.

### Ignoring SSL certificate errors (not recommended)
The instructions on the homepage use `curl` to download a Ruby script
from GitHub over HTTPS. Older versions of OS X may not have the necessary CA
certificates to verify GitHub's SSL certificate. In that case, you can
add `--insecure` to the `curl` command, forcing `curl` to ignore SSL certificate errors.
This will leave your connection to GitHub vulnerable to MITM, and is <strong>not recommended</strong>.
You may consider updating your CA certificates instead.

## Uninstallation
Uninstallation is documented in the [FAQ](FAQ.md).

<a name="1"><sup>1</sup></a> Not all formulae have CPU or OS requirements, but you can assume
    you will have trouble if you don’t conform. Also, you can find
    PowerPC and Tiger branches from other users in the fork network. See
    [Interesting Taps & Branches](Interesting-Taps-&-Branches.md).

<a name="2"><sup>2</sup></a> 10.7 or higher is recommended. 10.6 is supported on a
    best-effort basis. For 10.4 and 10.5, see [Tigerbrew](https://github.com/mistydemeo/tigerbrew).

<a name="3"><sup>3</sup></a> Most formulae require a compiler. A handful require a full Xcode
    installation. You can install Xcode, the CLT, or both; Homebrew
    supports all three configurations. Downloading Xcode may require an Apple Developer account on older versions of OS X. Sign up for free [here](https://developer.apple.com/register/index.action).

<a name="4"><sup>4</sup></a> The one-liner installation method found on
    [brew.sh](http://brew.sh) requires a Bourne-compatible shell (e.g.
    bash or zsh). Notably, fish, tcsh and csh will not work.
