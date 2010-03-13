Homebrew
========
Homebrew is the easiest and most flexible way to install the UNIX tools Apple
didn't include with OS X.


Requirements
------------
Almost all formula require OS X 10.5 or above and an Intel processor.


Quick Install
-------------
Install [Xcode][] and then run this script: <http://gist.github.com/323731>

If you want to install Homebrew somewhere other than `/usr/local` see the
[installation instructions][install].


Look dude, I know what I'm doing!
---------------------------------
Alright then… as long as you're sure:

    cd /usr/local
    sudo chown -R $USER .
    curl -Lsf http://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1


Example Usage
-------------
There's an overview on the [homepage][].


The Wiki
--------
The [wiki][] can answer your remaining questions.


Who Are You?
------------
I'm [Max Howell][mxcl] and I'm a splendid chap.


[wiki]:http://wiki.github.com/mxcl/homebrew
[install]:http://wiki.github.com/mxcl/homebrew/installation
[Xcode]:http://developer.apple.com/technology/xcode.html
[mxcl]:http://twitter.com/mxcl
[homepage]:http://mxcl.github.com/homebrew
