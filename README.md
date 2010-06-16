Homebrew
========
Features and usage are [summarized on the homepage][homepage].


Quick Install to /usr/local
---------------------------
[The script](http://gist.github.com/323731) will prompt for confirmation
before it does anything:

    ruby -e "$(curl -fsS http://gist.github.com/raw/436471/install_homebrew.rb)"

Afterwards, [install Xcode][xcode].


Umm… I thought I could install it anywhere?
-------------------------------------------
Indeed, you can. Refer to our [complete installation instructions][install].


Dude! Just give me a two-liner!
-------------------------------
Alright then… as long as you know what you are doing:

    sudo chown -R $USER /usr/local
    curl -Lsf http://github.com/mxcl/homebrew/tarball/master | tar xvz -C/usr/local --strip 1


More Documentation
==================
The [wiki][] is your friend.


Who Are You?
============
I'm [Max Howell][mxcl] and I'm a splendid chap.


[wiki]:http://wiki.github.com/mxcl/homebrew
[install]:http://wiki.github.com/mxcl/homebrew/installation
[xcode]:http://developer.apple.com/technology/xcode.html
[mxcl]:http://twitter.com/mxcl
[homepage]:http://mxcl.github.com/homebrew
