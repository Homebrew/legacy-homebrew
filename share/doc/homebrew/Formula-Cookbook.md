# Formula Cookbook
A formula is a package definition written in Ruby. It can be created with `brew create $URL` and installed with `brew install $FORMULA` and debugged with `brew install --debug --verbose $FORMULA`. Formulae use the [Formula API](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula) which provides various Homebrew-specific helpers.

## Homebrew Terminology

| Term           | Description                                                | Example                                              |
|----------------|------------------------------------------------------------|------------------------------------------------------|
| **Formula**    | The package definition                                     | `/usr/local/Library/Formula/foo.rb`                  |
| **Keg**        | The installation prefix of a **Formula**                   | `/usr/local/Cellar/foo/0.1`                          |
| **opt prefix** | A symlink to the active version of a **Keg**               | `/usr/local/opt/foo `                                |
| **Cellar**     | All **Kegs** are installed here                            | `/usr/local/Cellar`                                  |
| **Tap**        | An optional Git repository of **Formulae** and/or commands | `/usr/local/Library/Taps/homebrew/homebrew-versions` |
| **Bottle**     | Pre-built **Keg** used instead of building from source     | `qt-4.8.4.mavericks.bottle.tar.gz`                   |

## An Introduction

Homebrew uses Git for downloading updates and contributing to the project.

Homebrew installs to the `Cellar` it then symlinks some of the installation into `/usr/local` so that other programs can see what's going on. We suggest you `brew ls` a few of the kegs in your Cellar to see how it is all arranged.

Packages are installed according to their formulae, which live in `/usr/local/Library/Formula`. Check one out a simple one e.g. `brew edit etl` (or [etl](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/etl.rb)) or a more advanced one e.g. `brew edit git` or [Git](https://github.com/Homebrew/homebrew/tree/master/Library/Formula/git.rb).

# Basic Instructions

Make sure you run `brew update` before you start. This turns your Homebrew installation into a Git repository.

Before submitting a new formula make sure your package:

*   meets all our [Acceptable Formulae](Acceptable-Formulae.md) requirements
*   isn't already in Homebrew (check `brew search $FORMULA`)
*   isn't in another official [Homebrew tap](https://github.com/Homebrew)
*   isn't already waiting to be merged (check the [issue tracker](https://github.com/Homebrew/homebrew/issues))
*   is still supported by upstream (i.e. doesn't require extensive patching)
*   has a stable, tagged version (i.e. not just a GitHub repository with no versions). See [Interesting-Taps-&-Branches](Interesting-Taps-&-Branches.md) for where pre-release versions belong.
*   passes all `brew audit --strict --online $FORMULA` tests.

Before submitting a new formula make sure you read over our [contribution guidelines](https://github.com/Homebrew/homebrew/blob/master/.github/CONTRIBUTING.md).

## Grab the URL

Run `brew create` with a URL to the source tarball:

```shell
brew create https://example.com/foo-0.1.tar.gz
```

This creates `/usr/local/Library/Formula/foo.rb` and opens it in your `$EDITOR`. It'll look something like:

```ruby
class Foo < Formula
  desc ""
  homepage ""
  url "https://example.com/foo-0.1.tar.gz"
  sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"

  # depends_on "cmake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    # system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
```

If `brew` said `Warning: Version cannot be determined from URL` when doing the `create` step, you’ll need to explicitly add the correct [`version`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#version-class_method) to the formula and then save the formula.

Homebrew will try to guess the formula’s name from its URL. If it fails to do
so you can override this with `brew create <url> --set-name <name>`.

## Fill in the [`homepage`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#homepage%3D-class_method)

**We don’t accept formulae without a [`homepage`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#homepage%3D-class_method)!**

A SSL/TLS (https) [`homepage`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#homepage%3D-class_method) is preferred, if one is available.

Try to summarize from the [`homepage`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#homepage%3D-class_method) what the formula does in the [`desc`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#desc%3D-class_method)ription. Note that the [`desc`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#desc%3D-class_method)ription is automatically prepended with the formula name.

## Check the build system

```shell
brew install -i foo
```

You’re now at new prompt with the tarball extracted to a temporary sandbox.

Check the package’s `README`. Does the package install with `./configure`, `cmake`, or something else? Delete the commented out `cmake` lines if the package uses `./configure`.

## Check for dependencies

The `README` probably tells you about dependencies and Homebrew or OS X probably already has them. You can check for Homebrew dependencies with `brew search`. Some common dependencies that OS X comes with:

* `libexpat`
* `libGL`
* `libiconv`
* `libpcap`
* `libxml2`
* `Python`
* `Ruby`

There are plenty of others; check `/usr/lib` for them.

We generally try to not duplicate system libraries and complicated tools in core Homebrew but we do duplicate some commonly used tools.

One very special exception is OpenSSL. Anything that uses OpenSSL *should* be built using Homebrew’s shipped OpenSSL and our test bot's post-install `audit` will warn if it detects you haven't done this.

Homebrew’s OpenSSL is [`keg_only`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#keg_only-class_method) to avoid conflicting with the system so sometimes formulae need to have environmental variables set or special configuration flags passed to locate our OpenSSL. You can see this mechanism in the [clamav](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/clamav.rb#L28) formula. Usually this is unnecessary because when OpenSSL is specified as a dependency Homebrew temporarily prepends the `$PATH` with that prefix.

Homebrew maintains a special [tap that provides other useful system duplicates](https://github.com/Homebrew/homebrew-dupes).

*Important:* `$(brew --prefix)/bin` is NOT on the `$PATH` during formula installation. If you have dependencies at build time, you must specify them and brew will add them to the `$PATH` or create a [`Requirement`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Requirement).

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

A String (e.g. `"jpeg"`) specifies a formula dependency.

A Symbol (e.g. `:x11`) specifies a [`Requirement`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Requirement) which can be fulfilled by one or more formulae, casks or other system-wide installed software (e.g. X11).

A Hash (e.g. `=>`) specifies a formula dependency with some additional information. Given a single string key, the value can take several forms:

*   a Symbol (currently one of `:build`, `:optional`, `:recommended`).
    - `:build` means that dependency is a build-time only dependency so it can
      be skipped when installing from a bottle or when listing missing
      dependencies using `brew missing`.
    - `:optional` generates an implicit `with-foo` option for the formula.
      This means that, given `depends_on "foo" => :optional`, the user must pass `--with-foo` in order to use the dependency.
    - `:recommended` generates an implicit `without-foo` option, meaning that
      the dependency is enabled by default and the user must pass
      `--without-foo` to disable this dependency. The default
      description can be overridden using the normal option syntax (in this case, the option declaration must precede the dependency):

      ```ruby
      option "with-foo", "Compile with foo bindings" # This overrides the generated description if you want to
      depends_on "foo" => :optional # Generated description is "Build with foo support"
      ```

*   a String or an Array
    String values are interpreted as options to be passed to the dependency.
    You can also pass an array of strings, or an array of symbols and strings,
    in which case the symbols are interpreted as described above, and the
    strings are passed to the dependency as options.

    ```ruby
    depends_on "foo" => "with-bar"
    depends_on "foo" => %w{with-bar with-baz}
    depends_on "foo" => [:optional, "with-bar"]
    ```

## Specifying conflicts with other formulae

Sometimes there’s hard conflict between formulae, and it can’t be avoided or circumvented with [`keg_only`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#keg_only-class_method).

`mbedtls` is a good [example](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/mbedtls.rb) formula for minor conflict.

`mbedtls` ships and compiles a "Hello World" executable. This is obviously non-essential to `mbedtls`’s functionality, and conflict with the popular GNU `hello` formula would be overkill, so we just remove it.

[pdftohtml](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/pdftohtml.rb) provides an example of a serious
conflict, where both formula ship an identically-named binary that is essential to functionality, so a [`conflicts_with`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#conflicts_with-class_method) is preferable.

As a general rule, [`conflicts_with`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#conflicts_with-class_method) should be a last-resort option. It’s a fairly blunt instrument.

The syntax for conflict that can’t be worked around is:

```ruby
conflicts_with "blueduck", :because => "yellowduck also ships a duck binary"
```

## Formulae Revisions

In Homebrew we sometimes accept formulae updates that don’t include a version bump. These include resource updates, new patches or fixing a security issue with a formula.

Occasionally, these updates require a forced-recompile of the formula itself or its dependents to either ensure formulae continue to function as expected or to close a security issue. This forced-recompile is known as a [`revision`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#revision%3D-class_method) and inserted underneath the `homepage`/`url`/`sha` block.

Where a dependent of a formula fails against a new version of that dependency it must receive a [`revision`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#revision%3D-class_method). An example of such failure can be seen [here](https://github.com/Homebrew/homebrew/issues/31195) and the fix [here](https://github.com/Homebrew/homebrew/pull/31207).

[`revision`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#revision%3D-class_method)s are also used for formulae that move from the system OpenSSL to the Homebrew-shipped OpenSSL without any other changes to that formula. This ensures users aren’t left exposed to the potential security issues of the outdated OpenSSL. An example of this can be seen in [this commit](https://github.com/Homebrew/homebrew/commit/6b9d60d474d72b1848304297d91adc6120ea6f96).

## Double-check for dependencies

When you already have a lot of formulae installed, it's easy to miss a common dependency. You can double-check which libraries a binary links to with the `otool` command (perhaps you need to use `xcrun otool`):

```shell
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
```

## Specifying gems, Python modules, Go projects, etc. as dependencies

Homebrew doesn’t package already packaged language-specific libraries. These should be installed directly from `gem`/`cpan`/`pip` etc.

If you're installing an application then please use [`resource`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#resource-class_method)s for all the language-specific dependencies:

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

[jrnl](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/jrnl.rb) is an example of a formula that does this well. The end result means the user doesn't have use `pip` or Python and can just run `jrnl`.

[homebrew-pypi-poet](https://github.com/tdsmith/homebrew-pypi-poet) can help you generate resource stanzas for the dependencies of your Python application and [gdm](https://github.com/sparrc/gdm#homebrew) can help you generate go\_resource stanzas for the dependencies of your go application.

## Install the formula

```shell
brew install --verbose --debug foo
```

`--debug` will ask you to open an interactive shell if the build fails so you can try to figure out what went wrong.

Check the top of the e.g. `./configure` output. Some configure scripts do not recognize e.g. `--disable-debug`. If you see a warning about it, remove the option from the formula.

## Add a test to the formula

Please add a [`test do`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#test-class_method) block to the formula. This will be run by `brew test foo` and the [Brew Test Bot](Brew-Test-Bot.md).

The [`test do`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#test-class_method) block automatically creates and changes to a temporary directory which is deleted after run. You can access this [`Pathname`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Pathname) with the [`testpath`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#testpath-instance_method) function.

We want tests that don't require any user input and test the basic functionality of the application. For example `foo build-foo input.foo` is a good test and (despite their widespread use) `foo --version` and `foo --help` are bad tests. However, a bad test is better than no test at all.

See [cmake](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/cmake.rb) for an example of a formula with a good test. The formula writes a basic `CMakeLists.txt` file into the test directory then calls CMake to generate Makefiles. This test checks that CMake doesn't e.g. segfault during basic operation.  Another good example is [tinyxml2](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/tinyxml2.rb), which writes a small C++ source file into the test directory, compiles and links it against the tinyxml2 library and finally checks that the resulting program runs successfully.

## Manuals

Homebrew expects to find manual pages in `#{prefix}/share/man/...`, and not in `#{prefix}/man/...`.

Some software installs to `man` instead of `share/man`, so check the output and add a `"--mandir=#{man}"` to the `./configure` line if needed.

## A Quick Word on Naming

Name the formula like the project markets the product. So it’s `pkg-config`, not `pkgconfig`; `sdl_mixer`, not `sdl-mixer` or `sdlmixer`.

The only exception is stuff like “Apache Ant”. Apache sticks “Apache” in front of everything, but we use the formula name `ant`. We only include the prefix in cases like *GNUplot* (because it’s part of the name) and *GNU Go* (because everyone calls it “GNU go”—nobody just calls it “Go”). The word “Go” is too common and there are too many implementations of it.

If you’re not sure about the name check the homepage, and check the Wikipedia page and [what Debian call it](https://www.debian.org/distrib/packages).

Where Homebrew already has a formula called `foo` we typically do not accept requests to replace that formula with something else also named `foo`. This is to avoid both confusing and surprising users’ expectation.

When two formulae share an upstream name, e.g. [`AESCrypt`](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/aescrypt.rb) and [`AESCrypt`](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/aescrypt-packetizer.rb) the newer formula must typically adapt the name to avoid conflict with the current formula.

If you’re *still* not sure, just commit. We’ll apply some arbitrary rule and make a decision :wink:.

When importing classes, Homebrew will require the formula and then create an instance of the class. It does this by assuming the formula name can be directly converted to the class name using a `regexp`. The rules are simple:

*   `foo-bar.rb` => `FooBar`
*   `foobar.rb` => `Foobar`

Thus, if you change the name of the class, you must also rename the file. Filenames should be all lowercase.

Add aliases by creating symlinks in `Library/Aliases`.

## Audit the formula

You can run `brew audit --strict --online` to test formulae for adherence to Homebrew house style. The `audit` command includes warnings for trailing whitespace, preferred URLs for certain source hosts, and a lot of other style issues. Fixing these warnings before committing will make the process a lot quicker for everyone.

New formulae being submitted to Homebrew should run `brew audit --strict --online foo`. This command is performed by the Brew Test Bot on new submissions as part of the automated build and test process, and highlights more potential issues than the standard audit.

Use `brew info` and check if the version guessed by Homebrew from the URL is
correct. Add an explicit [`version`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#version-class_method) if not.

## Commit

Everything is built on Git, so contribution is easy:

```shell
brew update # required in more ways than you think (initializes the brew git repository if you don't already have it)
cd /usr/local
# Create a new git branch for your formula so your pull request is easy to
# modify if any changes come up during review.
git checkout -b <some-descriptive-name>
git add Library/Formula/foo.rb
git commit
```

The established standard for Git commit messages is:

* the first line is a commit summary of *50 characters or less*
* two (2) newlines, then
* explain the commit thoroughly

At Homebrew, we like to put the name of the formula up front like so: `foobar 7.3 (new formula)`.
This may seem crazy short, but you’ll find that forcing yourself to summarise the commit encourages you to be atomic and concise. If you can’t summarise it in 50-80 characters, you’re probably trying to commit two commits as one. For a more thorough explanation, please read Tim Pope’s excellent blog post, [A Note About Git Commit Messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).

The preferred commit message format for simple version updates is `foobar 7.3` and for fixes is `foobar: fix flibble matrix.`.

Ensure you reference any relevant GitHub issue e.g. `Closes #12345` in the commit message. Homebrew’s history is the first thing future contributors will look to when trying to understand the current state of formulae they’re interested in.

## Push

Now you just need to push your commit to GitHub.

If you haven’t forked Homebrew yet, [go to the repo and hit the fork button](https://github.com/Homebrew/homebrew).

If you have already forked Homebrew on GitHub, then you can manually push (just make sure you have been pulling from the Homebrew/homebrew master):

```shell
git push https://github.com/myname/homebrew/ <what-you-called-your-branch>
```

Now, please [open a pull request](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/How-To-Open-a-Homebrew-Pull-Request-(and-get-it-merged).md#how-to-open-a-homebrew-pull-request-and-get-it-merged) for your changes.

*   One formula per commit; one commit per formula
*   Keep merge commits out of the pull request

# Convenience Tools
## Messaging

Three commands are provided for displaying informational messages to the user:

*   `ohai` for general info
*   `opoo` for warning messages
*   `odie` for error messages and immediately exiting

In particular, when a test needs to be performed before installation use `odie` to bail out gracefully. For example:

```ruby
if build.with?("qt") && build.with("qt5")
  odie "Options --with-qt and --with-qt5 are mutually exclusive."
end
system "make", "install"
```

## `bin.install "foo"`

You’ll see stuff like that in other formulae. This moves the file `foo` into the Formula’s `bin` directory (`/usr/local/Cellar/pkg/0.1/bin`) and makes it executable (`chmod 0555 foo`).

## [`inreplace`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Utils/Inreplace)

A convenience function that can edit files in-place. For example:

`inreplace "path", before, after`

`before` and `after` can be strings or regular expressions. You can also use the block form:

```ruby
inreplace "path" do |s|
  s.gsub! /foo/, "bar"
end
```

Make sure you modify `s`! This block ignores the returned value.

`inreplace` should be used instead of patches when it is patching something that will never be accepted upstream e.g. make the software’s build system respect Homebrew’s installation hierarchy. If it's something that affects both Homebrew and MacPorts (i.e. OS X specific) it should be turned into an upstream submitted patch instead.

If you need modify variables in a `Makefile`, rather than using `inreplace`, pass them as arguments to `make`:

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

While [`patch`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#patch-class_method)es should generally be avoided, sometimes they are necessary.

When [`patch`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#patch-class_method)ing (i.e. fixing header file inclusion, fixing compiler warnings, etc.) the first thing to do is check whether or not the upstream project is aware of the issue. If not, file a bug report and/or submit your patch for inclusion. We may sometimes still accept your patch before it was submitted upstream but by getting the ball rolling on fixing the upstream issue you reduce the length of time we have to carry the patch around.

*Always justify a [`patch`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#patch-class_method) with a code comment!* Otherwise, nobody will know when it is safe to remove the patch, or safe to leave it in when updating the formula. The comment should include a link to the relevant upstream issue(s).

External [`patch`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#patch-class_method)es can be declared using resource-style blocks:

```ruby
patch do
  url "https://example.com/example_patch.diff"
  sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
end
```

A strip level of `-p1` is assumed. It can be overridden using a symbol argument:

```ruby
patch :p0 do
  url "https://example.com/example_patch.diff"
  sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
end
```

[`patch`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#patch-class_method)es can be declared in [`stable`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#stable-class_method), [`devel`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#devel-class_method), and [`head`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#head-class_method) blocks. NOTE: always use a block instead of a conditional, i.e. `stable do ... end` instead of `if build.stable? then ... end`.

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

```shell
brew install --interactive --git foo
# (make some edits)
git diff | pbcopy
brew edit foo
```

Now just paste into the formula after `__END__`.
Instead of `git diff | pbcopy`, for some editors `git diff >> path/to/your/formula/foo.rb` might help you ensure that the patch is not touched (e.g. white space removal, indentation, etc.)

# Advanced Formula Tricks

If anything isn’t clear, you can usually figure it out by `grep`ping the `Library/Formula` directory. Please submit a pull request to amend this document if you think it will help!

## Unstable versions (`devel`, `head`)

Formulae can specify alternate downloads for the upstream project’s [`devel`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#devel-class_method) release (unstable but not `master`/`trunk`) or [`head`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#head-class_method) (`master`/`trunk`).

### `devel`

The [`devel`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#devel-class_method) spec (activated by passing `--devel`) is used for a project’s unstable releases. It is specified in a block:

```ruby
devel do
  url "https://foo.com/foo-0.1.tar.gz"
  sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7"
end
```

You can test if the `devel` spec is in use with `build.devel?`.

### `head`

[`head`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#head-class_method) URLs (activated by passing `--HEAD`) build the development cutting edge. Specifying it is easy:

```ruby
class Foo < Formula
  head "https://github.com/mxcl/lastfm-cocoa.git"
end
```

Homebrew understands `git`, `svn`, and `hg` URLs, and has a way to specify `cvs` repositories as a URL as well. You can test whether the [`head`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#head-class_method) is being built with `build.head?`.

To use a specific commit, tag, or branch from a repository, specify [`head`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#head-class_method) with the `:tag` and `:revision`, `:revision`, or `:branch` option, like so:

```ruby
class Foo < Formula
  head "https://github.com/some/package.git", :revision => "090930930295adslfknsdfsdaffnasd13"
                                         # or :branch => "develop"
                                         # or :tag => "1_0_release",
                                         #    :revision => "090930930295adslfknsdfsdaffnasd13"
end
```

## Compiler selection

Sometimes a package fails to build when using a certain compiler. Since recent Xcodes no longer include a GCC compiler we cannot simply force the use of GCC. Instead, the correct way to declare this is the [`fails_with` DSL method](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#fails_with-class_method). A properly constructed [`fails_with`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#fails_with-class_method) block documents the latest compiler build version known to cause compilation to fail, and the cause of the failure. For example:

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

`build` takes a Fixnum (an integer; you can find this number in your `brew --config` output). `cause` takes a String, and the use of heredocs is encouraged to improve readability and allow for more comprehensive documentation.

[`fails_with`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#fails_with-class_method) declarations can be used with any of `:gcc`, `:llvm`, and `:clang`. Homebrew will use this information to select a working compiler (if one is available).

## Specifying the Download Strategy explicitly

To use one of Homebrew’s built-in download strategies, specify the `:using =>` flag on a `url` or `head`.  For example:

```ruby
class Python3 < Formula
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tar.xz"
  sha256 "b5b3963533768d5fc325a4d7a6bd6f666726002d696f1d399ec06b043ea996b8"
  head "https://hg.python.org/cpython", :using => :hg
```

Download strategies offered by Homebrew are:

| `:using` value | download strategy             |
|----------------|-------------------------------|
| `:bzr`         | `BazaarDownloadStrategy`      |
| `:curl`        | `CurlDownloadStrategy`        |
| `:cvs`         | `CVSDownloadStrategy`         |
| `:git`         | `GitDownloadStrategy`         |
| `:hg`          | `MercurialDownloadStrategy`   |
| `:nounzip`     | `NoUnzipCurlDownloadStrategy` |
| `:post`        | `CurlPostDownloadStrategy`    |
| `:svn`         | `SubversionDownloadStrategy`  |

If you need more control over the way files are downloaded and staged, you can create a custom download strategy and specify it using the [`url`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#url-class_method) method's `:using` option:


```ruby
class MyDownloadStrategy < SomeHomebrewDownloadStrategy
  # Does something cool
end

class Foo < Formula
  url "something", :using => MyDownloadStrategy
end
```

## Just moving some files

When your code in the install function is run, the current working directory is set to the extracted tarball.

So it is easy to just move some files:

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
      <td>A temporary directory somewhere on your system</td>
      <td><code>/private/tmp/[formula-name]-0q2b/[formula-name]</code></td>
    </tr>
  </tbody>
</table>

These can be used, for instance, in code such as

```ruby
bin.install Dir["output/*"]
```

to move binaries into their correct location into the cellar, and

```ruby
man.mkpath
```

to create the directory structure to the manual page location.

To install man pages into specific locations, use `man1.install "foo.1", "bar.1"`, `man2.install "foo.2"`, etc.

Note that in the context of Homebrew, [`libexec`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#libexec-instance_method) is reserved for private use by the formula and therefore is not symlinked into `HOMEBREW_PREFIX`.

## Adding optional steps

If you want to add an [`option`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#option-class_method):

```ruby
class Yourformula < Formula
  ...
  option "with-ham", "Description of the option"
  option "without-spam", "Another description"

  depends_on "foo" => :optional  # will automatically add a with-foo option
  ...
```

And then to define the effects the [`option`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#option-class_method)s have:

```ruby
if build.with? "ham"
  # note, no "with" in the option name (it is added by the build.with? method)
end

if build.without? "ham"
  # works as you'd expect. True if `--without-ham` was given.
end
```

[`option`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#option-class_method) names should be prefixed with the words `with` or `without`. For example, an option to run a test suite should be named `--with-test` or `--with-check` rather than `--test`, and an option to enable a shared library `--with-shared` rather than `--shared` or `--enable-shared`.

Note that [`option`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#option-class_method)s that aren’t `build.with? ` or `build.without?` should be deprecated with [`deprecated_option`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#deprecated_option-class_method). See [wget](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/wget.rb#L27-L31) for an example.


## File level operations

You can use the file utilities provided by Ruby's [`FileUtils`](http://www.ruby-doc.org/stdlib/libdoc/fileutils/rdoc/index.html). These are included in the `Formula` class, so you do not need the `FileUtils.` prefix to use them.

When creating symlinks, take special care to ensure they are *relative* symlinks. This makes it easier to create a relocatable bottle. For example, to create a symlink in `bin` to an executable in `libexec`, use

```ruby
bin.install_symlink libexec/"name"
```

instead of:

```ruby
ln_s libexec/"name", bin
```

The symlinks created by `install_symlink` are guaranteed to be relative. `ln_s` will only produce a relative symlink when given a relative path.

## Handling files that should persist over formula upgrades

For example, Ruby 1.9’s gems should be installed to `var/lib/ruby/` so that gems don’t need to be reinstalled when upgrading Ruby. You can usually do this with symlink trickery, or *better* a configure option.

### launchd plist files

Homebrew provides two Formula methods for launchd plist files. [`plist_name`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#plist_name-instance_method) will return e.g. `homebrew.mxcl.<formula>` and [`plist_path`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#plist_path-instance_method) will return e.g. `/usr/local/Cellar/foo/0.1/homebrew.mxcl.foo.plist`.

## Updating formulae

Eventually a new version of the software will be released. In this case you should update the `url` and `sha256`. If a `revision` line exists outside any `bottle do` block *and* the new release is stable rather than devel, it should be removed.

Please leave the `bottle do ... end`  block as-is; our CI system will update it when we pull your change.

Check if the formula you are updating is a dependency for any other formulae by running `brew uses UPDATED_FORMULA`. If it is a dependency please `brew reinstall` all the dependencies after it is installed and verify they work correctly.

# Style guide

Homebrew wants to maintain a consistent Ruby style across all formulae based on [Ruby Style Guide](https://github.com/styleguide/ruby). Other formulae may not have been updated to match this guide yet but all new ones should. Also:

* The order of methods in a formula should be consistent with other formulae (e.g.: `def install` goes before `def post_install`)
* An empty line is required before the `__END__` line

# Troubleshooting for people writing new formulae

### Version detection fails

Homebrew tries to automatically determine the [`version`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#version-class_method) from the [`url`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#url-class_method) in avoid duplication. If the tarball has an unusual name you may need to manually assign the [`version`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#version-class_method).

## Bad Makefiles

Not all projects have makefiles that will run in parallel so try to deparallelize by adding these lines to the `install` method:

```ruby
ENV.deparallelize
system "make"  # separate make and make install steps
system "make", "install"
```

If that fixes it, please open an [issue](https://github.com/Homebrew/homebrew/issues) so that we can fix it for everyone.

## Still won’t work?

Check out what MacPorts and Fink do:

```shell
brew -S --macports foo
brew -S --fink foo
```

# Superenv Notes

`superenv` is our "super environment" that isolates builds by removing `/usr/local/bin` and all user `PATH`s that are not essential for the build. It does this because user `PATH`s are often full of stuff that breaks builds. `superenv` also removes bad flags from the commands passed to `clang`/`gcc` and injects others (for example all `keg_only` dependencies are added to the `-I` and `-L` flags.

# Fortran

Some software requires a Fortran compiler. This can be declared by adding `depends_on :fortran` to a formula. `:fortran` is a `Requirement` that does several things.

First, it looks to see if you have set the `FC` environment variable. If it is set, Homebrew will use this value during compilation. If it is not set, it will check to see if `gfortran` is found in `PATH`. If it is, Homebrew will use its location as the value of `FC`. Otherwise, the `gcc` formula will be treated as a dependency and installed prior to compilation.

If you have set `FC` to a custom Fortran compiler, you may additionally set `FCFLAGS` and `FFLAGS`. Alternatively, you can pass `--default-fortran-flags` to `brew install` to use Homebrew's standard `CFLAGS`.

When using Homebrew's `gfortran` compiler, the standard `CFLAGS` are used and user-supplied values of `FCFLAGS` and `FFLAGS` are ignored for consistency and reproducibility reasons.

# How to start over (reset to  upstream `master`)

Have you created a real mess in git which stops you from creating a commit you want to submit to us? You might want to consider starting again from scratch. Your changes can be reset to the Homebrew's `master` branch by running:

```shell
git checkout -f master
git reset --hard origin/master
```
