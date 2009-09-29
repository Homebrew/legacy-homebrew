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
    custom compile flags? The Homebrew toolchain is carefully segregated so
    you can build stuff by hand but still end up with package management.

    Just install to the Cellar and then call brew ln to symlink that
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
    We optimise for (Snow) Leopard Intel, binaries are stripped, compile flags
    tweaked. Slow software sucks.

8.  Making the most of OS X  
    Homebrew knows how many cores you have thanks to RubyCocoa, so it makes
    sure when it builds it uses all of them, (unless you don't want it to of
    course).

    Homebrew knows exactly which Mac you have, and optimizes the software it
    builds as well as it possibly can.

    Homebrew can integrate with Ruby gems, CPAN and Python disttools. These
    tools exist already and do the job great. We don't duplicate packaging 
    effort, we just improve on it by making these tools install with more
    management options.

9.  No duplication  
    MacPorts is an autarky. You get a duplicate copy of zlib, OpenSSL, Python,
    etc. To cut a long story short, Homebrew doesn't. As a result everything
    you install has less dependencies and builds significantly faster.

10. Fork with Git  
    The formula are all on git, so just fork to add new packages, or add extra
    remotes to get packages from more exotic maintainers.

11. Surfing the cutting edge  
    If the package provides a git:// or svn:// url you can choose to install
    that instead and then update as often as you like.

12. Homebrew has a beer theme  
    Beer goggles will help you to evangelise Homebrew more effectively.

13. Homebrew helps get you chicks  
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
Homebrew requires no setup, but almost everything it installs is built from
source; so you need Xcode:

<http://developer.apple.com/technology/xcode.html>

Many build scripts assume MacPorts or Fink on OS X. Which isn't too much of a
problem until you uninstall them and stuff you built with Homebrew breaks. So
uninstall them (if you prefer, renaming their root folders is sufficient).

<http://trac.macports.org/wiki/FAQ#uninstall>  
<http://www.finkproject.org/faq/usage-fink.php#removing>

Now, download Homebrew:

    git clone git://github.com/mxcl/homebrew.git

If this leaves you shaking your head because you are installing Homebrew
*in order to* install git, then try [this installer script][sh] or [this
.pkg installer][pkg]. Note these are somewhat new and are not stamped 
"definitely works" yet.

[sh]: http://gist.github.com/179275
[pkg]: http://demaree.me/x/7

Homebrew is self-contained so once you've put it somewhere, it's ready to go.
Copy this directory anywhere you like. But we recommend installing to
/usr/local because:

1.  It is already in your path
2.  Build scripts always look in /usr/local for dependencies so it makes it
    easier for you personally to build and install software

You can move the location of Homebrew at a later time, although this *will*
break some tools because they hardcode their installtion prefixes into their
binaries. Homebrew does make more effort than competing solutions to prevent
this though.

Finally, if you don't install to /usr/local, you have to add the following to
your ~/.profile file:

    export PATH=`brew --prefix`/bin:$PATH
    export MANPATH=`brew --prefix`/share/man:$MANPATH

Don't sudo
----------
Well clearly you can sudo if you like. Homebrew is all about you doing it your
way. But the Homebrew recommendation is: don't sudo!

On OS X, this requires your user to be in the admin group, but it doesn't
require sudo:

    cpan -i MP3::Info

OS X is designed to minimise sudo use, you only need it for real-root-level
stuff. You know your /System and /usr are as clean and pure as the day you
bought your Mac because you didn't sudo. Sleep better at night!

If you are already the kind of guy who installed TextMate by dragging and
dropping it to /Applications, then you won't mind if libflac and pngcrush are
installed under your user privileges too. Lets face it; Homebrew is not
installing anything system-critical. Apple already did that.

Let this be the last sudo you do for quite some time:

    sudo chown -R `whoami`:staff `brew --prefix`

I already have a bunch of junk in /usr/local
--------------------------------------------
The easiest thing to do is just git clone into /usr/local. The files that are
there can remain there, Homebrew will never touch them.

Otherwise, delete everything and reinstall with Homebrew. Or merge it in by
hand.

How about mate and gitx and that?
---------------------------------
These tools install from TextMate and GitX into /usr/local/bin. They (and
other similar tools) can co-exist with Homebrew without requiring further
effort from yourself.


Uninstallation
==============
    cd `brew --prefix`
    rm -rf Cellar
    brew prune
    rm -rf Library .git
    rm bin/brew .gitignore README.md

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

    brew rm wget
    rm -rf /usr/local/Cellar/wget && brew prune

Two ways to list all files in a package:

    brew list wget
    find /usr/local/Cellar/wget

Search for a package to install:

    ls /usr/local/Library/Formula/

Search for a package already installed:

    ls /usr/local/Cellar/

Two ways to compute installed package sizes:

    brew info wget
    du /usr/local/Cellar/wget

Show expensive packages:

    du -md1 /usr/local/Cellar

A more thorough exploration of the brew command is available at the [Homebrew
wiki][wiki].


CPAN, EasyInstall, RubyGems
===========================
Homebrew doesn't reinvent the wheel. These tools are already designed to make
it easy to install Perl, Python and Ruby tools and libraries. So we insist
that you use them. However we don't think you should have to sudo, or install
to /usr, so we suggest you adapt the tools to install into Homebrew's prefix.

There are preliminary instructions on the [wiki][].


Contributing New Formulae
=========================
Formulae are simple Ruby scripts. Generate a formula with most bits filled-in:

    brew create http://foo.org/foobar-1.2.1.tar.bz2

Check it over and try to install it:

    brew install foobar

Check the [wiki][] for more detailed information and tips about contribution.

If you want your formula to become part of this distribution, fork
<http://github.com/mxcl/homebrew> and ask mxcl to pull. Alternatively maintain
your own distribution. Maybe you want to support Tiger? Or use special compile
flags? Go ahead that's what git is all about! :)


Licensing
=========
Homebrew is mostly BSD licensed although you should refer to each file to
confirm. Individual formulae are licensed according to their authors wishes.


FAQ
===
1. Are you excessively interested in beer?  
   Yes.

2. Was Homebrew devised under the influence of alcohol?  
   Yes.

3. Can Homebrew replace MacPorts?  
   Maybe. But remember, Homebrew is still incomplete. Be forgiving in your
   approach and be willing to fork and contribute fixes. Thanks!

4. Is there an IRC channel?  
   Yes, <irc://irc.freenode.net#machomebrew>.

[wiki]: http://wiki.github.com/mxcl/homebrew
