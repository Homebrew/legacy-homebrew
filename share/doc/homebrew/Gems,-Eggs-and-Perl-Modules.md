# Gems, Eggs and Perl Modules
On a fresh OS X installation there are three empty directories for
add-ons available to all users:

    /Library/Ruby
    /Library/Python
    /Library/Perl

Starting with OS X Lion (10.7), you need `sudo` to install to these like
so: `sudo gem install`, `sudo easy_install` or `sudo cpan -i`.

An option to avoid `sudo` is to use an access control list:
`chmod +a 'user:YOUR_NAME_HERE allow add_subdirectory,add_file,delete_child,directory_inherit' /Library/Python/2.7/site-packages`,
for example, will let you add packages to Python 2.7 as yourself. That
is probably safer than changing the group ownership of the directory.

### So why was I using sudo?
Habit maybe?

One reason is executables go in `/usr/local/bin`. Usually this isn’t a
writable location. But if you installed Homebrew as we recommend,
`/usr/local` will be writable without sudo. So now you are good to
install the development tools you need without risking a sudo.

### Python packages (eggs) without sudo
Rather than changing the rights on /Library/Python, we recommend the
following options:

### With a brewed Python - you don’t need sudo
Note, `easy_install` is deprecated. We install `pip` (or `pip3` for
python3) along with python/python3.

We set up distutils such that `pip install` will always put modules in
`$(brew --prefix)/lib/pythonX.Y/site-packages` and scripts in
`$(brew --prefix)/share/python`. Therefore, you won’t need `sudo`!

Do `brew info python` or `brew info python3` for precise information
about the paths. Note, a brewed Python still searches for modules in
`/Library/Python/X.Y/site-packages` and also in
`~/Library/Python/X.Y/lib/python/site-packages`.

### With system’s Python
_This is only recommended if you **don't** use a brewed Python._

On OS X, any [Python version X.Y also searches in
`~/Library/Python/X.Y/lib/python/site-packages` for
modules](https://docs.python.org/2/install/index.html#inst-alt-install-user).
That dir might not yet exist, but you can create it:
`mkdir -p ~/Library/Python/2.7/lib/python/site-packages`

To teach `easy_install` and `pip` to install there, either use the
`—user` switch or create a `~/.pydistutils.cfg` file with the
following content:

    [install]
    install_lib = ~/Library/Python/$py_version_short/lib/python/site-packages

### Using virtualenv - works with brewed and system’s Python

[Virtualenv](http://www.virtualenv.org/en/latest/) ships `pip` and
creates isolated Python environments with separate site-packages,
therefore you won’t need `sudo`.

Rubygems without sudo
---------------------

**If you use rbenv or RVM then you should ignore this stuff**

Brewed Ruby installs executables to `$(brew --prefix)/opt/ruby/bin`
without sudo. You should add this to your path. See the caveats in the
`ruby` formula for up-to-date information.

### With system’s Ruby

To make Ruby install to `/usr/local`, we need to add
`gem: -n/usr/local/bin` to your `~/.gemrc`. It’s YAML…so do it manually
or use this:

    echo "gem: -n/usr/local/bin" >> ~/.gemrc

**However all versions of RubyGems before 1.3.6 are buggy** and ignore
the above setting. Sadly a fresh install of Snow Leopard comes with
1.3.5. Currently the only known way to get round this is to upgrade
rubygems as root:

`sudo gem update --system`

### An Alternative

Just install everything into the Homebrew prefix like this:

`echo "export GEM_HOME=\"$(brew --prefix)\"" >> ~/.bashrc`

### It doesn’t work! I get some “permissions” error when I try to install stuff!

*Note, maybe you shouldn’t do this on Lion, since Apple have decided it
is not a good default.*

If you ever did a `sudo gem`, etc. before then a lot of files will have
been created chown root. Fix with:

`sudo chown -R $USER /Library/Ruby /Library/Perl /Library/Python`

Perl CPAN Modules without sudo
------------------------------

The Perl module local::lib works similarly to rbenv/RVM (although for
modules only, not perl installations). A simple solution that only
pollutes your /Library/Perl a little is to install
[local::lib](https://metacpan.org/pod/local::lib) with sudo:

`sudo cpan local::lib`

Note that will install some other dependencies like `Module::Install`.
Then put the appropriate incantation in your shell’s startup, e.g. for
`.bash_profile` you insert the below, for others see the
[local::lib](https://metacpan.org/pod/local::lib) docs.

`eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)`

Now (after you restart your shell) `cpan` or `perl -MCPAN -eshell` etc.
will install modules and binaries in `~/perl5` and the relevant
subdirectories will be in your `PATH` and `PERL5LIB` etc.

### Avoiding sudo altogether for Perl

If you don’t even want (or can’t) use sudo for bootstrapping
`local::lib` just manually install `local::lib` in
~/perl5 and add the relevant path to `PERL5LIB` before the .bashrc eval incantation.

Another alternative is to use `perlbrew` to install a separate copy of Perl in your home directory, or wherever you like :
```bash
curl -kL http://install.perlbrew.pl | bash
perlbrew install perl-5.16.2
echo ".~/perl5/perlbrew/etc/bashrc" >> ~/.bashrc
```
