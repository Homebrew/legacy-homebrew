Homebrew
========
Features and usage are [summarized on the homepage][homepage].


Quick Install to /usr/local
---------------------------
[This script][gist] will prompt for confirmation before it does anything:

    ruby -e "$(curl -fsSL https://gist.github.com/raw/323731/install_homebrew.rb)"

Afterwards, [install Xcode][xcode].


Umm… I thought I could install it anywhere?
-------------------------------------------
Indeed, you can. Refer to our [complete installation instructions][install].


Dude! Just give me a one-liner!
-------------------------------
Okay then, but please note this installs Homebrew as root and
[we recommend against that][sudo].

    curl -LsSf http://github.com/mxcl/homebrew/tarball/master | sudo /usr/bin/tar xvz -C/usr/local --strip 1


But what packages are available?
--------------------------------
Before installing you can
[browse the Formula folder on GitHub][browse-formulae].

After installing, you can use `brew search` to find packages or `brew server`
to browse packages off of a local web server.


More Documentation
==================
The [wiki][] is your friend.


Who Are You?
============
I'm [Max Howell][mxcl] and I'm a splendid chap.


[homepage]:http://mxcl.github.com/homebrew
[gist]:http://gist.github.com/323731
[xcode]:http://developer.apple.com/technologies/xcode.html
[install]:http://wiki.github.com/mxcl/homebrew/installation
[sudo]:http://wiki.github.com/mxcl/homebrew/installation#sudo
[wiki]:http://wiki.github.com/mxcl/homebrew
[mxcl]:http://twitter.com/mxcl
[browse-formulae]:http://github.com/mxcl/homebrew/tree/master/Library/Formula/
