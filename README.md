Homebrew
========
Homebrew is a package management system for OS X. In other words it is a tool
that helps you manage the installation of other open source software on your
Mac.

Here's why you may prefer Homebrew to the alternatives:

1.  Zero configuration installation  
    Copy the contents of this directory to /usr/local. Homebrew is now ready
    for use.

2.  Or… install anywhere!  
    You can actually stick this directory anywhere. Like ~/.local or /opt or
    /lol if you like. You can even move this directory somewhere else later.
    Homebrew never changes any files outside of its prefix.

3.  The GoboLinux approach  
    Packages are installed into their own prefix (eg. /usr/local/Cellar/wget)
    and then symlinked into the Homebrew prefix (eg. /usr/local).

    This way the filesystem is the package database and packages can be
    managed with existing command line tools. For example, you can
    uninstall with rm -rf, list with find, query with du. It also means you
    can install multiple versions of software or libraries and switch
    on demand.

    Of course, you don't have to do anything by hand, we also provide a
    convenient and fully-featured four-letter tool called brew.

4.  You don't have to sudo  
    It's up to you.

5.  Create new package descriptions in seconds  
    Package descriptions (formula) are simple Ruby scripts. Generate a
    template with:

        brew create http://foo.com/tarball-0.8.9.tgz

    Or edit an existing formula:

        brew edit foo

6.  Package descriptions not required  
    MacPorts doesn't support the beta version? Need an older version? Need
    custom compile flags? The Homebrew tool-chain is carefully segregated so
    you can build stuff by hand but still end up with package management.

    Just install to the Cellar and then call brew link to symlink that
    installation into your PATH, eg.

        ./configure --prefix=/usr/local/Cellar/wget/1.10
        make install
        brew ln wget

    Or Homebrew can figure out the prefix:

        ./configure `brew diy`
        cmake . `brew diy`

7.  Optimization  
    We optimize for (Snow) Leopard Intel, binaries are stripped, compile flags
    are tuned to your exact Mac model. Slow software sucks.

8.  Making the most of OS X  
    A touch of RubyCocoa, a cheeky sysctl query or two and a smattering of
    FSEvent monitoring. In these manic days of cross-platform development,
    it's sometimes a welcome relief to use something that is better because
    it isn't too generalized.

9.  No duplication  
    MacPorts is an autarky -- you get a duplicate copy of zlib, OpenSSL,
    Python, etc. Homebrew uses what is already there, and consequently,
    most stuff has zero dependencies and builds faster.

    We resist packaging stuff that is already packaged. So we have a [wiki][]
    page that describes how best to use RubyGems, Pip (or easy_install) and
    CPAN with OS X and Homebrew.

10. Fork with Git  
    The formula are all on git, so just fork to add new packages, or add extra
    remotes to get packages from more exotic maintainers.

11. Surfing the cutting edge  
    If the package provides a git://, svn://, cvs:// or hg:// url you can
    choose to install that instead and then update as often as you like.

12. Homebrew has a beer theme  
    Beer goggles will help you to evangelise Homebrew more effectively.

13. Homebrew can help hook you up  
    There's no conclusive scientific evidence as yet, but I firmly believe
    it's just a matter of time and statistics.

I know I've made it sound so awesome you can hardly wait to embrace the fresh,
hoppy taste of Homebrew, but I should point out that it is really new and
still under heavy development. Also:

1.  It's a little more hands-on than the competition. For example, we don't
    set up PostgreSQL for you after installing it, but we do provide
    instructions. This isn't apathy, it's by design -- Homebrew doesn't make
    assumptions about how you want your software to run. You have to have some
    knowledge or be willing to learn to use Homebrew for some tasks.

2.  Dependency resolution and updates are basic or not working yet.

3.  We don't support PowerPC or OS X less than Tiger (though you could always
    maintain your own fork for such things if you like…)

Max Howell -- <http://twitter.com/mxcl>


Installation
============
You can install Homebrew anywhere:

    mkdir homebrew
    curl -L http://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C homebrew

Homebrew can already be used, try it:

    homebrew/bin/brew install git
    homebrew/bin/brew list git

Notice how Homebrew installed Git to homebrew/bin/git. Homebrew never touches
files outside its prefix.

We recommend installing to /usr/local because:
----------------------------------------------
1. It's already in your PATH
2. It makes it easy to install stuff like Ruby Gems

Build tools all look to /usr/local for library dependencies they need. Thus
it should be much less troublesome to build your own gems, etc.

But… don't sudo!
----------------
Homebrew can be used with or without sudo, but, OS X was designed to
minimise sudo use, you only need it occasionally. For example, as long as your
user is in the admin group, this just works:

    cpan -i MP3::Info

Using sudo all the time is annoying, but far worse — it conditions you to type
in your root password without thinking about it. Homebrew compliments OS X
so you are unlikely to install anything that really needs to be chown:root.
Let this be your last sudo for some time:

    sudo chown -R `whoami` /usr/local

_NOTE_: If you already installed, eg. MySQL into /usr/local then the recursive
chown _may_ break it. Fixing MySQL should be as simple as:

    sudo chown -R mysql:mysql /usr/local/mysql

Installing to /usr/local
------------------------
    curl -L http://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C /usr/local

Homebrew can co-exist with any software already installed in its prefix.

You may prefer this third party [installer script][sh] or [.pkg installer][pkg].

Updating
--------
To update you need git (brew install git). The following will soon be part of
the brew update command, it merges with whatever is already there:

    cd /usr/local
    git init
    git remote add origin git://github.com/mxcl/homebrew.git
    git pull origin master

Note the above steps can also be used to install Homebrew if you prefer.

Building Stuff
--------------
Almost everything Homebrew installs is written in C, so you need Xcode:

<http://developer.apple.com/technology/xcode.html>


Uninstallation
==============
    cd `brew --prefix`
    rm -rf Cellar
    brew prune
    rm -rf Library .git* bin/brew README.md

It is worth noting that if you installed somewhere like /usr/local then these
uninstallation steps will leave that directory exactly like it was before
Homebrew was installed. Unless you manually added new stuff there, in which
case those things will still be there too.


Sample Usage
============
Install wget:

    brew install wget

Update package list:

    cd /usr/local && git pull

Two ways to delete a package:

    brew uninstall wget
    rm -rf /usr/local/Cellar/wget && brew prune

Two ways to list all files in a package:

    brew list wget
    find /usr/local/Cellar/wget

Two ways to search for a package to install:

    brew search
    ls /usr/local/Library/Formula/

Two ways to see what is already installed:

    brew list
    ls /usr/local/Cellar/

Two ways to compute installed package sizes:

    brew info wget
    du /usr/local/Cellar/wget

Show expensive packages:

    du -md1 /usr/local/Cellar


Contributing New Formulae
=========================
Create a formula thusly.

    brew create http://example.com/foo-1.2.1.tar.bz2

Homebrew automatically opened Library/Formula/foo.rb in your $EDITOR. You can
now install it:

    brew install git

Now check the [wiki][] for more information.


Licensing
=========
Homebrew is mostly BSD licensed although you should refer to each file to
confirm. Individual formulae are licensed according to their authors' wishes.


The Wiki
========
The [wiki][] has almost excessive detail on most topics.

[wiki]:http://wiki.github.com/mxcl/homebrew
