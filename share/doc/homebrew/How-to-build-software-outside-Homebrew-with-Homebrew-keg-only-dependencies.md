# How to build software outside Homebrew with Homebrew keg-only dependencies.

### What does keg-only mean?

See the [FAQ](FAQ.md) on this one. It’s a common question.

As an example:

*OpenSSL isn’t symlinked into my $PATH and non-Homebrew builds can’t find it!*

That’s because Homebrew keeps it locked away in its prefix, accessible only via its opt directory. `keg_only` = Not symlinked into the `$PATH` by default.

### But how do I get non-Homebrew builds to find those tools?

A number of people in this situation are either forcefully linking `keg_only` tools with `brew link --force` or moving default system utilities out of the `$PATH` and replacing them with manually-created symlinks to the Homebrew-provided tool.

Please, *please* do not remove OS X native tools and forcefully replace them with symlinks back to the Homebrew-provided tool. Homebrew doesn’t enforce `keg_only` onto formulae unless there’s a specific, good reason for doing so, and that reason is usually that forcing that link breaks a whole boat full of builds.

It is also incredibly difficult to debug a build failure if you make changes to the Homebrew-provided tools installed that `brew` is unaware of. `brew link --force` deliberately creates a warning in `brew doctor` to let both you and maintainers know that link exists and could be causing issues.

If you’ve linked something and there’s no problems at all? Awesome, feel free to ignore the `brew doctor` error. But *please* don’t try to go around it. It’s really hard to help you out if we don’t know the full picture, and we *want* to be able to help you if you get stuck.

### Alright. Stop complaining at me, I get it - but how do I use those tools outside of Homebrew?

Useful, reliable alternatives exist should you desire to use `keg_only` tools outside of Homebrew’s build processes:

----
You can set flags to give configure scripts or Makefiles a nudge in the right direction. An example of flag setting:
   `./configure --prefix=/Users/Dave/Downloads CFLAGS=-I$(brew --prefix)/opt/openssl/include LDFLAGS=-L$(brew --prefix)/opt/openssl/lib`

An example using `pip`:

   `CFLAGS=-I$(brew --prefix)/opt/icu4c/include LDFLAGS=-L$(brew --prefix)/opt/icu4c/lib pip install pyicu`

----

You can temporarily prepend your `$PATH` with the tool’s bin directory, such as:
   `export PATH=$(brew --prefix)/opt/openssl/bin:$PATH`
This will immediately move that folder to the front of your `$PATH`, ensuring any build script that searches the `$PATH` will find it.

Changing your `$PATH` using that command ensures the change only exists for the duration of that shell session. Once you are no longer in that terminal tab/window, the `$PATH` ceases to be prepended.

----

If the tool you are attempting to build is [pkg-config](https://en.wikipedia.org/wiki/Pkg-config) aware, you can amend your `PKG_CONFIG_PATH` to find that `keg_only` utility’s `.pc` file, if it has one. Not all formulae ship with those files.

An example of that is:
   `export PKG_CONFIG_PATH=$(brew --prefix)/opt/openssl/lib/pkgconfig `

If you’re curious about `PKG_CONFIG_PATH` and which paths it searches by default, `man pkg-config` goes into detail on that.

You can also get `pkg-config` to detail its currently searched paths with:
   `pkg-config --variable pc_path pkg-config`
