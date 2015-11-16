# Formula Cookbook
Making a formula is easy. Just `brew create URL` and then `brew install $FORMULA` (perhaps with `--debug --verbose`). Basically, a formula is a Ruby file. You can place it anywhere you want (local or remote) and install it by pointing to the file or URL.

We want your formula to be awesome, and the cookbook will tell you how.

## API documentation
Some people find it easier to jump straight into API documentation rather than a walkthrough. If you're one of these check out the [Formula API](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula) which shows all the stuff you can use in a Homebrew Formula.

## Terminology - Homebrew speak

<table>
  <tbody>
    <tr>
      <th>Formula</th>
      <td>The package definition</td>
      <td><code>/usr/local/Library/Formula/foo.rb</code></td>
    </tr>
    <tr>
      <th>Keg</th>
      <td>The installation prefix of a Formula</td>
      <td><code>/usr/local/Cellar/foo/0.1</code></td>
    </tr>
    <tr>
      <th>opt prefix</th>
      <td>A symlink to the active version of a keg</td>
      <td><code>/usr/local/opt/foo</code></td>
    </tr>
    <tr>
      <th>Cellar</th>
      <td>All kegs are installed here</td>
      <td><code>/usr/local/Cellar</code></td>
    </tr>
    <tr>
      <th>Tap</th>
      <td>An optional repository (git) of Formulae</td>
      <td><code>/usr/local/Library/Taps</code></td>
    </tr>
    <tr>
      <th>Bottle</th>
      <td>Pre-built (binary) Keg that can be unpacked</td>
      <td><code>qt-4.8.4.mountain_lion.bottle.1.tar.gz</code></td>
    </tr>
  </tbody>
</table>

_More general: `brew --prefix` and `brew --repository` instead of `/usr/local` but lets KISS._


## An Introduction

Did you see `/usr/local/.git`? Homebrew is built on Git. This means you can just do your work in `/usr/local` and merge in upstream changes as you go.

Homebrew installs to the `Cellar`, it then symlinks some of the installation into `/usr/local` so that other programs can see what's going on. We suggest you `brew ls` a few of the kegs in your Cellar to see how it is all arranged.

Packages are installed according to their formulae, which live in `$(brew --repository)/Library/Formula`. Check some out. You can view any formula at anytime; e.g. `brew edit wget`.



# Basic Instructions

Make sure you run `brew update` before you start. This turns your Homebrew installation into a Git repository.

Before contributing, make sure your package:

*   meets all our [Acceptable Formulae](Acceptable-Formulae.md) requirements
*   isn't already in Homebrew (check `brew search $FORMULA`)
*   isn't in another [Homebrew tap](https://github.com/Homebrew)
*   isn't already waiting to be merged (check the [issue tracker](https://github.com/Homebrew/homebrew/issues))
*   is still supported by upstream
*   has a stable, tagged version (i.e. not just a GitHub repository with no versions). See [Interesting-Taps-&-Branches](Interesting-Taps-&-Branches.md) for where pre-release and head-only versions belong.
*   passes all `brew audit --strict --online $FORMULA` tests.

Make sure you search thoroughly (all aliases!). We don’t want you to waste your time.

Be sure to look over the [contributing guidelines](https://github.com/Homebrew/homebrew/blob/master/CONTRIBUTING.md) as well.


## Will we merge your formula?

Probably. But we have rules to keep the quality and goals of Homebrew intact: Please read [Acceptable Formulae](Acceptable-Formulae.md).

## Some Quick Examples Before You Get Started

Formulae aren’t that complicated. [etl](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/etl.rb) is as simple as it gets.

And then [Git](https://github.com/Homebrew/homebrew/tree/master/Library/Formula/git.rb) and [flac](https://github.com/Homebrew/homebrew/tree/master/Library/Formula/flac.rb) show more advanced functionality.

## Grab the URL

All you need to make a formula is a URL to the tarball.

    brew create https://example.com/foo-0.1.tar.gz

This creates:

`$HOMEBREW_REPOSITORY/Library/Formula/foo.rb`

And opens it in your `$EDITOR`. It'll look like:

```ruby
class Foo < Formula
  url "https://example.com/foo-0.1.tar.gz"
  homepage ""
  sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"

  # depends_on "cmake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
#   system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
```

**Note:**  If `brew` said `Warning: Version cannot be determined from URL` when doing the `create` step, you’ll need to explicitly add the correct version to the formula with `version "foo"` **and then save the formula**. `brew install` should then proceed without any trouble.

**Note:** If `brew` said `No formula found for "php54-timezonedb". Searching open pull requests...` and you are writing a Tap, you should run `brew tap --repair`.

**Note:** Homebrew will try to guess the formula’s name from its URL. If it
fails to do so you can use `brew create <url> --set-name <name>`.

## Fill in the Homepage

**We don’t accept formulae without homepages!**

SSL/TLS (https) homepage is preferred, if one is available.

Homebrew now has a description field (`desc`). Try and summarize this from the homepage.

## Check the build system

    brew install -i foo

You’re now at new prompt with the tarball extracted to a temporary sandbox.

Check the package’s `README`. Does the package install with `autotools`, `cmake`, or something else? Delete the commented out cmake lines if the package uses autotools (i.e. if it has a `configure` script).


## Check for dependencies

The `README` probably tells you about dependencies. Homebrew or OS X probably already has them. You can check for Homebrew deps with `brew search`. These are the common deps that OS X comes with:

* `libexpat`
* `libGL`
* `libiconv`
* `libpcap`
* `libxml2`
* `Python`
* `Ruby`

There are plenty of others. Check `/usr/lib` to see.

We try to not duplicate libraries and complicated tools in core Homebrew. We dupe some common tools though. But generally, we avoid dupes because it’s one of Homebrew’s foundations. (And it causes build and usage problems!)

The one special exception is OpenSSL. Anything that uses OpenSSL *should* be built using Homebrew’s shipped OpenSSL and our test bot's post-install audit will warn of this when it is detected. (*Of course, there are exceptions to the exception. Not everything can be forced onto our OpenSSL)*.

Because Homebrew’s OpenSSL is `keg_only` to avoid conflicting with the system, sometimes formulae need to have environmental variables set or special configuration flags passed to locate our preferred OpenSSL; you can see this mechanism in the [clamav](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/clamav.rb#L28) formula. Usually this is unnecessary because when OpenSSL is specified as a dependency Homebrew temporarily prepends the $PATH with that prefix.

Homebrew maintains a special [tap that provides other useful dupes](https://github.com/Homebrew/homebrew-dupes).

*Important:* Since the introduction of `superenv`, `brew --prefix`/bin is NOT on the `$PATH` during formula installation. If you have dependencies at build time, you must specify them and brew will add them to the `$PATH`. You can test around this with `--env=std`.


## Specifying other formulae as dependencies

```ruby
class Foo < Formula
  depends_on "jpeg"
  depends_on "gtk+" => :optional
  depends_on "readline" => :recommended
  depends_on "boost" => "with-icu"
  depends_on :x11 => :optional
end
```

A String specifies a formula dependency.

A Symbol specifies a special conditional dependency, such as X11.

A Hash specifies a formula dependency with some additional information. Given a single string key, the value can take several forms:
*   a Symbol (currently one of `:build`, `:optional`, `:recommended`).
    -   `:build` tags that dependency as a build-time only dependency, meaning it can be safely ignored
        when installing from a bottle and when listing missing dependencies using `brew missing`.
    -   `:optional` generates an implicit `with-foo` option for the formula. This means that, given
        `depends_on "foo" => :optional`, the user must pass `--with-foo` in order to enable the dependency.
    -   `:recommended` generates an implicit `without-foo` option, meaning that the dependency is enabled
        by default and the user must pass `--without-foo` to disable this dependency. The default
        description can be overridden using the normal option syntax (in this case, the option declaration must precede the dependency):

    ```ruby
    option "with-foo", "Compile with foo bindings" # This overrides the generated description if you want to
    depends_on "foo" => :optional # Generated description is "Build with foo support"
    ```

*   a String or an Array
    String values are interpreted as options to be passed to the dependency. You can also pass
    an array of strings, or an array of symbols and strings, in which case the symbols are
    interpreted as described above, and the strings are passed to the dependency as options.

    ```ruby
    depends_on "foo" => "with-bar"
    depends_on "foo" => %w{with-bar with-baz}
    depends_on "foo" => [:optional, "with-bar"]
    ```


## Specifying other formulae as conflicts

Sometimes there’s hard conflict between formulae, and it can’t be avoided or circumvented with `keg_only`.

`mbedtls` is a good [example](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/mbedtls.rb) formula for minor conflict.

`mbedtls` ships and compiles a "Hello World" executable. This is obviously non-essential to `mbedtls`’s functionality, and conflict with the popular GNU `hello` formula would be overkill, so we just remove it.

[pdftohtml](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/pdftohtml.rb) provides an example of a serious
conflict, where both formula ship a identically-named binary that is essential to functionality, so a `conflicts_with` is preferable.

As a general rule, `conflicts_with` should be a last-resort option. It’s a fairly blunt instrument.

The syntax for conflict that can’t be worked around is

```ruby
conflicts_with "blueduck", :because => "yellowduck also ships a duck binary"
```

## Formulae Revisions

In Homebrew we sometimes accept formulae updates that don’t include a version bump. These include homepage changes, resource updates, new patches or fixing a security issue with a formula.

Occasionally, these updates require a forced-recompile of the formula itself or its dependents to either ensure formulae continue to function as expected or to close a security issue. This forced-recompile is known as a `revision` and inserted underneath the homepage/url/sha block.

Where a dependent of a formula fails against a new version of that dependency it must receive a `revision`. An example of such failure can be seen [here](https://github.com/Homebrew/homebrew/issues/31195) and the fix [here](https://github.com/Homebrew/homebrew/pull/31207).

`Revisions` are also used for formulae that move from the system OpenSSL to the Homebrew-shipped OpenSSL without any other changes to that formula. This ensures users aren’t left exposed to the potential security issues of the outdated OpenSSL. An example of this can be seen in [this commit](https://github.com/Homebrew/homebrew/commit/6b9d60d474d72b1848304297d91adc6120ea6f96).

## Double-check for dependencies

When you already have a lot of brews installed, it's easy to miss a common dependency like `glib` or `gettext`.

You can double-check which libraries a binary links to with the `otool` command (perhaps you need to use `xcrun otool`):

    $ otool -L /usr/local/bin/ldapvi
    /usr/local/bin/ldapvi:
	/usr/local/opt/openssl/lib/libssl.1.0.0.dylib (compatibility version 1.0.0, current version 1.0.0)
	/usr/local/opt/openssl/lib/libcrypto.1.0.0.dylib (compatibility version 1.0.0, current version 1.0.0)
	/usr/local/lib/libglib-2.0.0.dylib (compatibility version 4201.0.0, current version 4201.0.0)
	/usr/local/opt/gettext/lib/libintl.8.dylib (compatibility version 10.0.0, current version 10.2.0)
	/usr/local/opt/readline/lib/libreadline.6.dylib (compatibility version 6.0.0, current version 6.3.0)
	/usr/local/lib/libpopt.0.dylib (compatibility version 1.0.0, current version 1.0.0)
	/usr/lib/libncurses.5.4.dylib (compatibility version 5.4.0, current version 5.4.0)
	/System/Library/Frameworks/LDAP.framework/Versions/A/LDAP (compatibility version 1.0.0, current version 2.4.0)
	/usr/lib/libresolv.9.dylib (compatibility version 1.0.0, current version 1.0.0)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1213.0.0)


## Specifying gems, Python modules, Go projects, etc. as dependencies

Homebrew doesn’t package already packaged language-specific libraries. These should be installed directly from `gem`/`cpan`/`pip` etc.

If you're installing an application then please locally vendor all the language-specific dependencies:

```ruby
class Foo < Formula
  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.tar.gz"
    sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
  end

  def install
    resource("pycrypto").stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
  end
end
```

[jrnl](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/jrnl.rb) is an example of a formula that does this well. The end result means the user doesn't have to faff with `pip` or Python and can just run `jrnl`.

[homebrew-pypi-poet](https://github.com/tdsmith/homebrew-pypi-poet) can help you generate resource stanzas for the dependencies of your Python application.

Similarly, [homebrew-go-resources](https://github.com/samertm/homebrew-go-resources) can help you generate go\_resource stanzas for the dependencies of your go application.

If your formula needs a gem or python module and it can't be made into a resource you’ll need to check for these external dependencies:

```ruby
class Foo < Formula
  depends_on "mg" => :ruby
  depends_on "json" => :python
  depends_on "Authen::NTLM" => :perl
end
```

Note that we probably won't accept the formulae in this case; it's a far worse user experience than vendoring libraries with resources.

## Test the formula

Exit out of the interactive shell.

    brew install --verbose --debug foo

Debug will ask you to open an interactive shell when the build fails so you can try to figure out what went wrong.

Check the top of the `./configure` output (if applicable)! Some configure scripts do not recognize `--disable-debug`. If you see a warning about it, remove the option from the formula.

## Add a test to the formula

Please add a `test do` block to the formula. This will be run by `brew test foo` and the [Brew Test Bot](Brew-Test-Bot.md).

The `test do` block automatically creates and changes to a temporary directory which is deleted after run. You can access this Pathname with the `testpath` function.

We want tests that don't require any user input and test the basic functionality of the application. For example `foo build-foo input.foo` is a good test and (despite their widespread use) `foo --version` and `foo --help` are bad tests. However, a bad test is better than no test at all.

See [cmake](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/cmake.rb) for an example of a formula with a good test. A basic `CMakeLists.txt` file is written CMake uses it to generate Makefiles. This test checks that CMake doesn't e.g. segfault during basic operation.

## Manuals

Homebrew expects to find man pages in `[prefix]/share/man/...`, and not in `[prefix]/man/...`.

Some software installs to man instead of `share/man`, so check the output and add a `"--mandir=#{man}"` to the `./configure` line if needed.


## A Quick Word on Naming

**THE NAME IS VERY IMPORTANT!**

Name the formula like the project markets the product. So it’s `pkg-config`, not `pkgconfig`; `sdl_mixer`, not `sdl-mixer` or `sdlmixer`.

The only exception is stuff like “Apache Ant”. Apache sticks “Apache” in front of everything, but we use the formula name `ant`. We only include the prefix in cases like *GNUplot* (because it’s part of the name) and *GNU Go* (because everyone calls it “GNU go”—nobody just calls it “Go”). The word “Go” is too common and there are too many implementations of it.

If you’re not sure about the name check the homepage, and check the Wikipedia page.

[ALSO CHECK WHAT DEBIAN CALLS IT!](https://www.debian.org/distrib/packages)

Where Homebrew already has a formula called `foo` we typically do not accept requests to replace that formula with something else also named `foo`. This is to avoid both confusing and surprising users’ expectation.

When two formulae share an upstream name, e.g. [`AESCrypt`](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/aescrypt.rb) and [`AESCrypt`](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/aescrypt-packetizer.rb) the newer formula must typically adapt the name to avoid conflict with the current formula.

If you’re *still* not sure, just commit. We’ll apply some arbitrary rule and make a decision ;)

When importing classes, Homebrew will require the formula and then create an instance of the class. It does this by assuming the formula name can be directly converted to the class name using a `regexp`. The rules are simple:

*   `foo-bar.rb` => `FooBar`
*   `foobar.rb` => `Foobar`

Thus, if you change the name of the class, you must also rename the file. Filenames should be all lowercase.

Add aliases by creating symlinks in `Library/Aliases`.


## Audit the formula

You can run `brew audit` to test formulae for adherence to Homebrew house style. The audit command includes warnings for trailing whitespace, preferred URLs for certain source hosts, and a lot of other style issues. Fixing these warnings before committing will make the process a lot smoother for us.

New formulae being submitted to Homebrew should run `brew audit <formula name> --strict --online`. This command is performed by the Brew Test Bot on new submissions as part of the automated build and test process, and highlights more potential issues than the standard audit.

Use `brew info` and check if the version guessed by Homebrew from the URL is
correct. Add an explicit `version` if not.

## Commit

Everything is built on Git, so contribution is easy:

    brew install git # if you already have git installed, skip this command
    brew update # required in more ways than you think (initializes the brew git repository if you don't already have it)
    cd `brew --repository`
    # Create a new git branch for your formula so your pull request is easy to
    # modify if any changes come up during review.
    git checkout -b <some-descriptive-name>
    git add Library/Formula/foo.rb
    git commit

The established standard for Git commit messages is:

* the first line is a commit summary of *50 characters or less*, then
* two (2) newlines, then
* explain the commit throughly

At Homebrew, we like to put the name of the formula up front like so: "foobar 7.3 (new formula)".
This may seem crazy short, but you’ll find that forcing yourself to summarise the commit encourages you to be atomic and concise. If you can’t summarise it in 50-80 characters, you’re probably trying to commit two commits as one. For a more thorough explanation, please read Tim Pope’s excellent blog post, [A Note About Git Commit Messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).

The preferred commit message format for simple version updates is "foobar 7.3".

Ensure you reference any relevant GitHub issue `#12345` in the commit message. Homebrew’s history is the first thing future contributors will look to when trying to understand the current state of formulae they’re interested in.


## Push

Now you just need to push back to GitHub.

If you haven’t forked Homebrew yet, [go to the repo and hit the fork button](https://github.com/Homebrew/homebrew).

If you have already forked Homebrew on GitHub, then you can manually push (just make sure you have been pulling from the Homebrew/homebrew master):

    git push git@github.com:myname/homebrew.git <what-you-called-your-branch>

Now, please open a Pull Request (on your GitHub repo page) for new and updated brews.

*   One formula per commit; one commit per formula
*   Keep merge commits out of the request
*   If you have any merge or mixup commits, please [squash](http://gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html) them.

If a commit touches multiple files, or isn’t one logical bug fix, or a file is touched in multiple commits, we’ll probably ask you to `rebase` and `squash` your commits. For this reason, you should avoid pushing to your `master` branch. Note, after rebase and/or squash, you'll need to push with `--force` to your remote.


# Overview of the Formula Install Process
<!-- TODO rewrite this. It is outdated, there are more layers now, and the implementation details discussed here are not relevant or useful to most users anyway. -->

*   The result of `Formula.download_strategy` is instantiated.
*   `DownloadStrategy.fetch` is called (downloads tarball, checks out git repository, etc.)
*   A temporary sandbox is created in `/tmp/$formulaname`
*   `DownloadStrategy.stage` is called (extracts tarball to above sandbox, exports git repository to sandbox, etc.)
*   Patches are applied
*   Current directory is changed to the stage root (so when you `system make`, it works)
*   `Formula.install` is called
*   Anything installed to the keg is cleaned (see later)
*   The keg is symlinked into Homebrew’s prefix
*   Caveats are displayed


# Convenience Tools

## Messaging

Three commands are provided for displaying informational messages to the user:

*   `ohai` for general info
*   `opoo` for warning messages
*   `onoe` for error messages

In particular, when a test needs to be performed before installation use `onoe` to bail out gracefully. For example:

```ruby
if some_test?
  system "make", "install"
else
  onoe "Error! Something is wrong."
end
```


## bin.install "foo"

You’ll see stuff like that in other formulae. This installs the file foo into the Formula’s `bin` directory (`/usr/local/Cellar/pkg/0.1/bin`) and makes it executable (`chmod 0555 foo`).

## inreplace

A convenience function that can edit files in-place. For example:

`inreplace "path", before, after`

`before` and `after` can be strings or regexps. You can also use the block form:

```ruby
inreplace "path" do |s|
  s.gsub! /foo/, "bar"
end
```

Make sure you modify `s`! This block ignores the returned value.

`inreplace` should be used instead of patches when it is patching something that will never be accepted upstream e.g. make the software’s build system respect Homebrew’s installation hierarchy. If it's Homebrew and MacPorts or OS X specific it should be turned into a patch instead.

If you need modify variables in a Makefile, rather than using `inreplace`, pass them as arguments to make:

```rb
system "make", "target", "VAR2=value1", "VAR2=value2", "VAR3=values can have spaces"
```

```rb
args = %W[
  CC=#{ENV.cc}
  PREFIX=#{prefix}
]

system "make", *args
```

Note that values *can* contain unescaped spaces if you use the multiple-argument form of `system`.

## Patches

While patches should generally be avoided, sometimes they are necessary.

When patching (i.e. fixing header file inclusion, fixing compiler warnings, etc.) the first thing to do is check whether or not the upstream project is aware of the issue. If not, file a bug report and/or submit your patch for inclusion. We may sometimes still accept your patch before it was submitted upstream but by getting the ball rolling on fixing the upstream issue you reduce the length of time we have to carry the patch around.

*Always, always, always justify a patch with a code comment!* Otherwise, nobody will know when it is safe to remove the patch, or safe to leave it in when updating the formula. The comment should include a link to the relevant upstream issue(s).

External patches can be declared using resource-style blocks:

```rb
patch do
  url "https://example.com/example_patch.diff"
  sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
end
```

A strip level of -p1 is assumed. It can be overridden using a symbol argument:

```rb
patch :p0 do
  url "https://example.com/example_patch.diff"
  sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
end
```

Patches can be declared in stable, devel, and head blocks. NOTE: always use a block instead of a conditional, i.e. `stable do ... end` instead of `if build.stable? then ... end`.

```rb
stable do
  # some other things...

  patch do
    url "https://example.com/example_patch.diff"
    sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
  end
end
```

Embedded (__END__) patches can be declared like so:

```rb
patch :DATA
patch :p0, :DATA
```

with the patch data included at the end of the file:

```
__END__
diff --git a/foo/showfigfonts b/foo/showfigfonts
index 643c60b..543379c 100644
--- a/foo/showfigfonts
+++ b/foo/showfigfonts
@@ -14,6 +14,7 @@
…
```

Patches can also be embedded by passing a string. This makes it possible to provide multiple embedded patches while making only some of them conditional.
```rb
patch :p0, "..."
```

In embedded patches, the string `HOMEBREW_PREFIX` is replaced with the value of the constant `HOMEBREW_PREFIX` before the patch is applied.


## Creating the diff

    brew install --interactive --git foo
    …
    (make some edits)
    …
    git diff | pbcopy
    brew edit foo

Now just paste into the formula after `__END__`.
Instead of `git diff | pbcopy`, for some editors `git diff >> path/to/your/formula/foo.rb` might help you that the diff is not touched (e.g. white space removal, indentation, etc.)



# Advanced Formula Tricks

If anything isn’t clear, you can usually figure it out with some `grep` and the `Library/Formula` directory. Please amend this document if you think it will help!


## Unstable versions (`HEAD`, `devel`)

Formulae can specify alternate downloads for the upstream project’s `devel` release (unstable but not `trunk`) or `HEAD` (`master/trunk`).

### HEAD

HEAD URLs (activated by passing `--HEAD`) build the development cutting edge. Specifying it is easy:

```ruby
class Foo < Formula
  head "https://github.com/mxcl/lastfm-cocoa.git"
end
```

Homebrew understands `git`, `svn`, and `hg` URLs, and has a way to specify `cvs` repositories as a URL as well. You can test whether the `HEAD` is being built with `build.head?`.

To use a specific commit, tag, or branch from a repository, specify head with the `:tag` and `:revision`, `:revision`, or `:branch` option, like so:

```ruby
class Foo < Formula
  head "https://github.com/some/package.git", :revision => "090930930295adslfknsdfsdaffnasd13"
                                         # or :branch => "develop"
                                         # or :tag => "1_0_release",
                                         #    :revision => "090930930295adslfknsdfsdaffnasd13"
end
```

Formulae that only have `head` versions should be submitted to [homebrew/headonly](https://github.com/Homebrew/homebrew-headonly) instead of Homebrew/homebrew.

### devel

The "devel" spec (activated by passing `--devel`) is used for a project’s unstable releases. It is specified in a block:

```ruby
devel do
  url "https://foo.com/foo-0.1.tar.gz"
  sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
end
```

You can test if the "devel" spec is in use with `build.devel?`.

## Compiler selection

Sometimes a package fails to build when using a certain compiler. Since recent Xcode no longer includes a GCC compiler, we cannot simply force the use of GCC. Instead, the correct way to declare this is the `fails_with` DSL method. A properly constructed `fails_with` block documents the latest compiler build version known to cause compilation to fail, and the cause of the failure. For example:

```ruby
fails_with :llvm do
  build 2335
  cause <<-EOS.undent
    The "cause" field should include a short summary of the error. Include
    the URLs of any relevant information, such as upstream bug reports. Wrap
    the text at a sensible boundary (~72-80 characters), but do not break
    URLs over multiple lines.
    EOS
end
```

`build` takes a Fixnum (you can find this number in your `brew --config` output). `cause` takes a string, and the use of heredocs is encouraged to improve readability and allow for more comprehensive documentation.

`fails_with` declarations can be used with any of `:gcc`, `:llvm`, and `:clang`. Homebrew will use this information to select a working compiler (if one is available).


## Specifying the Download Strategy explicitly

To use one of Homebrew’s built-in download strategies, specify the `:using =>` flag on a `url` or `head`.  For example:

```ruby
class Python3 < Formula
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tar.xz"
  sha256 "b5b3963533768d5fc325a4d7a6bd6f666726002d696f1d399ec06b043ea996b8"
  head "https://hg.python.org/cpython", :using => :hg
```

The downloaders offered by Homebrew are:

<table>
  <thead>
    <tr>
      <th>Value of <code>:using</code></th>
      <th>Corresponds To</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>:bzr</code></td>
      <td><code>BazaarDownloadStrategy</code></td>
    </tr>
    <tr>
      <td><code>:curl</code></td>
      <td><code>CurlDownloadStrategy</code></td>
    </tr>
    <tr>
      <td><code>:cvs</code></td>
      <td><code>CVSDownloadStrategy</code></td>
    </tr>
    <tr>
      <td><code>:git</code></td>
      <td><code>GitDownloadStrategy</code></td>
    </tr>
    <tr>
      <td><code>:hg</code></td>
      <td><code>MercurialDownloadStrategy</code></td>
    </tr>
    <tr>
      <td><code>:nounzip</code></td>
      <td><code>NoUnzipCurlDownloadStrategy</code></td>
    </tr>
    <tr>
      <td><code>:post</code></td>
      <td><code>CurlPostDownloadStrategy</code></td>
    </tr>
    <tr>
      <td><code>:svn</code></td>
      <td><code>SubversionDownloadStrategy</code></td>
    </tr>
  </tbody>
</table>


If you need more control over the way files are downloaded and staged, you can create a custom download strategy and specify it using the `url` method's `:using` option:


```ruby
class MyDownloadStrategy < SomeHomebrewDownloadStrategy
  # Does something cool
end

class Foo < Formula
  url "something", :using => MyDownloadStrategy
end
```

Specifying download strategies can be useful when used with a local repo, where a plain URL would not let you specify how to access it. For example:

```ruby
class Bar < Formula
  head "/users/abc/src/git.git", :using => :git
end
```


## Just copying some files

When your code in the install function is run, the current working directory is set to the extracted tarball.

So it is easy to just copy some files:

```ruby
prefix.install "file1", "file2"
```

Or everything:

```ruby
prefix.install Dir["output/*"]
```

Generally we'd rather you were specific about what files or directories need to be installed rather than installing everything.

### Variables for directory locations

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Default</th>
      <th>Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th><code>HOMEBREW_PREFIX</code></th>
      <td><code>/usr/local</code></td>
      <td></td>
    </tr>
    <tr>
      <th><code>prefix</code></th>
      <td><code>#{HOMEBREW_PREFIX}/Cellar/#{name}/#{version}</code></td>
      <td><code>/usr/local/Cellar/foo/0.1</code></td>
    </tr>
    <tr>
      <th><code>opt_prefix</code></th>
      <td><code>#{HOMEBREW_PREFIX}/opt/#{name}</code></td>
      <td><code>/usr/local/opt/foo</code></td>
    </tr>
    <tr>
      <th><code>bin</code></th>
      <td><code>#{prefix}/bin</code></td>
      <td><code>/usr/local/Cellar/foo/0.1/bin</code></td>
    </tr>
    <tr>
      <th><code>doc</code></th>
      <td><code>#{prefix}/share/doc/foo</code></td>
      <td><code>/usr/local/Cellar/foo/0.1/share/doc/foo</code></td>
    </tr>
    <tr>
      <th><code>include</code></th>
      <td><code>#{prefix}/include</code></td>
      <td><code>/usr/local/Cellar/foo/0.1/include</code></td>
    </tr>
    <tr>
      <th><code>info</code></th>
      <td><code>#{prefix}/share/info</code></td>
      <td><code>/usr/local/Cellar/foo/0.1/share/info</code></td>
    </tr>
    <tr>
      <th><code>lib</code></th>
      <td><code>#{prefix}/lib</code></td>
      <td><code>/usr/local/Cellar/foo/0.1/lib</code></td>
    </tr>
    <tr>
      <th><code>libexec</code></th>
      <td><code>#{prefix}/libexec</code></td>
      <td><code>/usr/local/Cellar/foo/0.1/libexec</code></td>
    </tr>
    <tr>
      <th><code>man</code></th>
      <td><code>#{prefix}/share/man</code></td>
      <td><code>/usr/local/Cellar/foo/0.1/share/man</code></td>
    </tr>
    <tr>
      <th><code>man[1-8]</code></th>
      <td><code>#{prefix}/share/man/man[1-8]</code></td>
      <td><code>/usr/local/Cellar/foo/0.1/share/man/man[1-8]</code></td>
    </tr>
    <tr>
      <th><code>sbin</code></th>
      <td><code>#{prefix}/sbin</code></td>
      <td><code>/usr/local/Cellar/foo/0.1/sbin</code></td>
    </tr>
    <tr>
      <th><code>share</code></th>
      <td><code>#{prefix}/share</code></td>
      <td><code>/usr/local/Cellar/foo/0.1/share</code></td>
    </tr>
    <tr>
      <th><code>pkgshare</code></th>
      <td><code>#{prefix}/share/foo</code></td>
      <td><code>/usr/local/Cellar/foo/0.1/share/foo</code></td>
    </tr>
    <tr>
      <th><code>etc</code></th>
      <td><code>#{HOMEBREW_PREFIX}/etc</code></td>
      <td><code>/usr/local/etc</code></td>
    </tr>
    <tr>
      <th><code>var</code></th>
      <td><code>#{HOMEBREW_PREFIX}/var</code></td>
      <td><code>/usr/local/var</code></td>
    </tr>
    <tr>
      <th><code>buildpath</code></th>
      <td>A temporary dir somewhere on your system</td>
      <td><code>/private/tmp/[formula-name]-0q2b/[formula-name]</code></td>
    </tr>
  </tbody>
</table>

These can be used, for instance, in code such as

```ruby
bin.install Dir["output/*"]
```

to install binaries into their correct location into the cellar, and

```ruby
man.mkpath
```

to create the directory structure to the man location.

To install man pages into specific locations, use `man1.install "foo.1", "bar.1"`, `man2.install "foo.2"`, etc.

Note that in the context of Homebrew, `libexec` is reserved for private use by the formula and therefore is not symlinked into `HOMEBREW_PREFIX`.

### Installation without linking into `/usr/local` (keg-only)

If you only need a program for a dependency and it does not need to be linked for public use in `/usr/local`, specify

```ruby
keg_only "This is my rationale."
```

in the Formula class.


## Adding optional steps

If you want to add an option:

```ruby
class Yourformula < Formula
  ...
  option "with-ham", "Description of the option"
  option "without-spam", "Another description"

  depends_on "foo" => :optional  # will automatically add a with-foo option
  ...
```

And then to define the effects the options have:

```ruby
if build.with? "ham"
  # note, no "with" in the option name (it is added by the build.with? method)
end

if build.without? "ham"
  # works as you'd expect. True if `--without-ham` was given.
end
```

Option names should be prefixed with the words `with` or `without`. For example, an option to run a test suite should be named `--with-test` or `--with-check` rather than `--test`, and an option to enable a shared library `--with-shared` rather than `--shared` or `--enable-shared`.

Note that options that aren’t ` build.with? ` or ` build.without? ` should be actively deprecated where possible. See [wget](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/wget.rb#L27-L31) for an example.


## File level operations

You can use the file utilities provided by Ruby (`FileUtils`). These are included in the `Formula` class, so you do not need the `FileUtils.` prefix to use them. They are documented [here](http://www.ruby-doc.org/stdlib/libdoc/fileutils/rdoc/index.html).

When creating symlinks, take special care to ensure they are *relative* symlinks. This makes it easier to create a relocatable bottle. For example, to create a symlink in `bin` to an executable in `libexec`, use

```rb
bin.install_symlink libexec/"name"
```

*not*

```rb
ln_s libexec/"name", bin
```

The symlinks created by `install_symlink` are guaranteed to be relative. `ln_s` will only produce a relative symlink when given a relative path.

## Handling files that should persist over formula upgrades

For example, Ruby 1.9’s gems should be installed to `var/lib/ruby/` so that gems don’t need to be reinstalled when upgrading Ruby. You can usually do this with symlink trickery, or *better* a configure option.

### launchd plist files

Homebrew provides two Formula methods for launchd plist files. `plist_name` will return `homebrew.mxcl.<formula>`, and `plist_path` will return, for example, `/usr/local/Cellar/foo/0.1/homebrew.mxcl.foo.plist`.

## Updating formulae

Eventually a new version of the software will be released. In this case you should update the `url` and `sha256`. Please leave the `bottle do ... end`  block as-is; our CI system will update it when we pull your change.

Check if the formula you are updating is a dependency for any other formulae by running `brew uses UPDATED_FORMULA`. If it is a dependency please `brew reinstall` all the dependencies after it is installed and verify they work correctly.

# Style guide

Homebrew wants to maintain a consistent Ruby style across all formulae based on [Ruby Style Guide](https://github.com/styleguide/ruby). Other formulae may not have been updated to match this guide yet but all new ones should. Also:

* The order of methods in a formula should be consistent with other formulae (e.g.: `def patches` goes before `def install`)
* An empty line is required before the `__END__` line



# Troubleshooting for people writing new formulae

### Version detection fails

Homebrew tries to automatically determine the version from the URL in order to save on duplication. If the tarball has a funny name though, you may have to assign the version number:

```ruby
class Foobar
  version "0.7"
end
```

## Bad Makefiles

Not all projects have makefiles that will run in parallel so try to deparallelize:

    brew edit foo

Add all this to the formula (so there will already be a class line, don’t add another or change that, and there’s already an install function, don't add another one, add the lines in the install function below to the top of the problem formula’s install function).

```ruby
class Foo < Formula
  skip_clean :all
  def install
    ENV.deparallelize
    ENV.no_optimization
    system "make"  # separate make and make install steps
    system "make", "install"
  end
end
```

If that fixes it, please open an [issue](https://github.com/Homebrew/homebrew/issues) so that we can fix it for everyone.

## Still won’t work?

Check out what MacPorts and Fink do:

`brew -S --macports foo`

`brew -S --fink foo`



# Superenv Notes

`superenv` is a "super" environment that tries to improve reliability for the general case. But it does make making formula harder.

To not use `superenv`, install with `--env=std`.

Superenv isolates builds by removing `/usr/local/bin` and all user-PATHs that are not determined to be essential to the build. It does this because other PATHs are full of stuff that breaks builds. (We have 15,000 tickets as testament!)

`superenv` tries to remove bad-flags from the commands passed to `clang`/`gcc` and injects others (for example all `keg_only` dependencies are added to the `-I` and `-L` flags. If superenv troubles you, try to `brew install --env=std` and report to us if that fixes it.

# Fortran

Some software requires a Fortran compiler. This can be declared by adding `depends_on :fortran` to a formula. `:fortran` is a special dependency that does several things.

First, it looks to see if you have set the `FC` environment variable. If it is set, Homebrew will use this value during compilation. If it is not set, it will check to see if `gfortran` is found in `PATH`. If it is, Homebrew will use its location as the value of `FC`. Otherwise, the `gcc` formula will be treated as a dependency and installed prior to compilation.

If you have set `FC` to a custom Fortran compiler, you may additionally set `FCFLAGS` and `FFLAGS`. Alternatively, you can pass `--default-fortran-flags` to `brew install` to use Homebrew's standard `CFLAGS`.

When using Homebrew's own gfortran compiler, the standard `CFLAGS` are used and user-supplied values of `FCFLAGS` and `FFLAGS` are ignored for consistency and reproducibility reasons.


# How to start over (reset to `master`)?

Have you created a real mess in git which paralyzes you to create the commit you just want to push?
Then you might consider start from scratch.
Your changes will be discarded in favour of the `master` branch:

`git checkout master`

`git reset --hard FETCH_HEAD`
