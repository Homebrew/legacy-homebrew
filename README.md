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

    This way packages can be managed with existing command line tools. You can
    uninstall with rm -rf, list with find, query with du. It also means you
    can easily install multiple versions of software or libraries and switch
    on demand.

    Of course you don't have to do anything by hand, we also provide a
    convenient and fully-featured four-letter tool called brew.

4.  You don't have to sudo  
    It's up to you. We recommend not--see the relevant later section.

5.  Easy package creation  
    Packages are just Ruby scripts. Generate a template with:

        brew create http://foo.com/tarball-0.8.9.tgz

    Homebrew will automatically open it for you to tweak with TextMate or
    $EDITOR.

    Or edit an existing formula:

        brew edit foo

6.  DIY package installation  
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

    This means you can also install multiple versions of the same package and
    switch on demand.

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
    Python, etc. Homebrew isn't, and as a result everything you install has
    less dependencies and builds significantly faster.

    Homebrew can integrate with Ruby gems, CPAN and Python EasyInstall. These
    tools exist already and do the job great. We don't duplicate packaging 
    effort, we just improve on it by making these tools install with more
    management options.

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

Why you might not want to use Homebrew:

1.  It's a little more hands-on than the competition. For example, we don't
    set up postgresql for you after installing it, but we do provide
    instructions. This isn't apathy, it's by design -- Homebrew doesn't make
    assumptions about how you want your software to run. You have to have some
    knowledge or be willing to learn to use Homebrew for some tasks.

2.  Dependency resolution and updates are basic or not working yet.

I know I've made it sound so awesome you can hardly wait to rip MacPorts out
and embrace the fresh, hoppy taste of Homebrew, but I should point out that it
is really new and still under heavy development. Thanks!

Max Howell -- <http://twitter.com/mxcl>


Installation
============
Homebrew is pretty flexible in how it can be installed and used. What follows
are probably the simplest methods.

Download
--------
    mkdir homebrew
    curl -L http://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C homebrew

Homebrew can already be used, try it:

    homebrew/bin/brew install git
    homebrew/bin/brew list git

Notice how Homebrew installed Git to homebrew/bin/git. Homebrew never touches
files outside its prefix.

Installing to /usr/local
------------------------
We think /usr/local is the best location for Homebrew because:

1. It's already in your PATH
2. Other software checks /usr/local for stuff (eg. RubyGems)
3. Building your own software is easier when dependencies are in /usr/local

But… don't sudo!
----------------
Well clearly you can sudo if you like. Homebrew is all about you doing it your
way. But the Homebrew recommendation is: don't sudo!

On OS X, this requires your user to be in the admin group, but it doesn't
require sudo:

    cpan -i MP3::Info

OS X is designed to minimise sudo use, you only need it for real root-level
stuff. You know your /System and /usr are as clean and pure as the day you
bought your Mac because you didn't sudo. Sleep better at night!

If you are already the kind of guy who installed TextMate by dragging and
dropping it to /Applications, then you won't mind if libflac and pngcrush are
installed under your user privileges too. Lets face it; Homebrew is not
installing anything system-critical. Apple already did that.

Let this be the last sudo you do for quite some time:

    sudo chown -R `whoami` /usr/local

_NOTE_: Performing the above command *may* break some programs that are already
installed in /usr/local. One specific example is mysql. Fixing mysql may be
as simple as:

    sudo chown -R mysql:mysql `brew --prefix`/mysql

But! I already have a bunch of junk in /usr/local
-------------------------------------------------
Homebrew can co-exist with any software already installed in its prefix.

Installing to /usr/local
------------------------
    curl -L http://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C /usr/local

You may prefer this third party [installer script][sh] or [.pkg installer][pkg].

Using git to install
--------------------
If you already have git installed then this is the easiest way to install:

    cd /usr/local
    git init
    git remote add origin git://github.com/mxcl/homebrew.git
    git pull origin master

Building Stuff
--------------
Almost everything Homebrew installs is written in C, so you need Xcode:

<http://developer.apple.com/technology/xcode.html>

Many build scripts assume MacPorts or Fink on OS X. Which isn't too much of a
problem until you uninstall them and stuff you built with Homebrew breaks. So
uninstall them (if you prefer, renaming their root folders is sufficient).

<http://trac.macports.org/wiki/FAQ#uninstall>  
<http://www.finkproject.org/faq/usage-fink.php#removing>


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

A more thorough exploration of the brew command is available at the [Homebrew
wiki][wiki].


RubyGems, Python EasyInstall and CPAN
=====================================
These tools are already designed to make it easy to install Ruby, Python and
Perl stuff. So we resist the temptation to duplicate this packaging effort and
thus avoid accepting such formula into the main tree (although sometimes it is
necessary or prudent).

However it's a nice option to get these other packaging systems to install
into Homebrew and there are work-in-progress instructions for how to do this
on the [wiki][].


Contributing New Formulae
=========================
Formulae are simple Ruby scripts. Generate a formula with most bits filled-in:

    brew create http://example.com/foo-1.2.1.tar.bz2

Check it over and try to install it:

    brew install foo

Check the [wiki][] for more detailed information and tips for contribution.

If you want your formula to become part of this distribution, fork
<http://github.com/mxcl/homebrew> and send mxcl a pull-request. Alternatively
maintain your own distribution. Maybe you want to support Tiger? Or use
special compile flags? Go ahead that's what git is all about! :)

The easiest way to fork is with the [github-gem][], so potentially this is
your workflow:

    brew create http://example.com/foo-1.2.1.tar.bz2
    git commit Library/Formula/foo.rb
    github fork
    git push myname master
    github pull-request


Licensing
=========
Homebrew is mostly BSD licensed although you should refer to each file to
confirm. Individual formulae are licensed according to their authors' wishes.


FAQ
===
1. Can Homebrew replace MacPorts?  
   Maybe. But remember, Homebrew is still incomplete. Be forgiving in your
   approach and be willing to fork and contribute fixes. Thanks!

2. Is there an IRC channel?  
   Yes, <irc://irc.freenode.net#machomebrew>.
   
3. And it's on Twitter?  
   Yes, <http://twitter.com/machomebrew>.


[wiki]: http://wiki.github.com/mxcl/homebrew
[github-gem]: http://github.com/defunkt/github-gem
[sh]: http://gist.github.com/203926
[pkg]: http://demaree.me/x/7
