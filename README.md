Homebrew
========
Features and usage are [summarized on the homepage][homepage].


Quick Install to /usr/local
---------------------------
[This script][gist] will prompt for confirmation before it does anything:

    ruby -e "$(curl -fsS http://gist.github.com/raw/323731/install_homebrew.rb)"

Afterwards, [install Xcode][xcode].


Umm… I thought I could install it anywhere?
-------------------------------------------
Indeed, you can. Refer to our [complete installation instructions][install].


Dude! Just give me a one-liner!
-------------------------------
Okay then, but please note this installs Homebrew as root and
[we recommend against that][sudo].

    curl -LsSf http://github.com/mxcl/homebrew/tarball/master | sudo tar xvz -C/usr/local --strip 1


More Documentation
==================
The [wiki][] is your friend.


Who Are You?
============
I'm [Max Howell][mxcl] and I'm a splendid chap.


[homepage]:http://mxcl.github.com/homebrew
[gist]:http://gist.github.com/323731
[xcode]:http://developer.apple.com/technology/xcode.html
[install]:http://wiki.github.com/mxcl/homebrew/installation
[sudo]:http://wiki.github.com/mxcl/homebrew/installation#sudo
[wiki]:http://wiki.github.com/mxcl/homebrew
[mxcl]:http://twitter.com/mxcl
