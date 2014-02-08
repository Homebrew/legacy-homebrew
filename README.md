Linuxbrew
=========
An experimental fork of Homebrew for Linux.

Installation
------------

* Debian or Ubuntu: `sudo apt-get install build-essential curl git ruby libbz2-dev libexpat-dev libncurses-dev`
* Fedora: `sudo yum groupinstall 'Development Tools' && sudo yum install curl git ruby bzip2-devel expat-devel ncurses-devel`
* `git clone https://github.com/Homebrew/linuxbrew.git ~/.linuxbrew`
* Add to your `.bashrc` or `.zshrc`:

 ```sh
 export PATH="$HOME/.linuxbrew/bin:$PATH"
 export LD_LIBRARY_PATH="$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH"
 ```

* `brew install $WHATEVER_YOU_WANT`

Requirements
------------

* **Ruby** 1.8.6 or newer

What Packages Are Available?
----------------------------
1. You can [browse the Formula directory on GitHub][formula].
2. Or type `brew search` for a list.
3. Or visit [braumeister.org][braumeister] to browse packages online.

More Documentation
------------------
`brew help` or `man brew` or check our [wiki][].

Troubleshooting
---------------
First, please run `brew update` and `brew doctor`.

Second, read the [Troubleshooting Checklist](https://github.com/Homebrew/homebrew/wiki/troubleshooting).

**If you don't read these it will take us far longer to help you with your problem.**

Who Are You?
------------
Homebrew is maintained by the [core contributors][team].

Homebrew was originally created by [Max Howell][mxcl].

License
-------
Code is under the [BSD 2 Clause (NetBSD) license][license].

Donations
---------
We accept tips through [Gittip][tip].

[![Gittip](http://img.shields.io/gittip/Homebrew.png)](https://www.gittip.com/Homebrew/)

[home]:http://brew.sh
[wiki]:http://wiki.github.com/Homebrew/homebrew
[mxcl]:http://twitter.com/mxcl
[formula]:http://github.com/Homebrew/homebrew/tree/master/Library/Formula/
[braumeister]:http://braumeister.org
[license]:https://github.com/Homebrew/homebrew/tree/master/Library/Homebrew/LICENSE
[team]:https://github.com/Homebrew?tab=members
[tip]:https://www.gittip.com/Homebrew/
