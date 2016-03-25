# How to build software outside Homebrew with Homebrew `keg-only` dependencies

## What does `keg-only` mean?

The [FAQ](FAQ.md) briefly explains this.

As an example:

*OpenSSL isn’t symlinked into my `$PATH` and non-Homebrew builds can’t find it!*

This is because Homebrew keeps it locked inside its individual prefix, rather than symlinking to the publicly-available location, usually `/usr/local`.

## Advice on potential workarounds.

A number of people in this situation are either forcefully linking `keg_only` tools with `brew link --force` or moving default system utilities out of the `$PATH` and replacing them with manually-created symlinks to the Homebrew-provided tool.

*Please* do not remove OS X native tools and forcefully replace them with symlinks back to the Homebrew-provided tool. Doing so can and likely will cause significant breakage when attempting to build software.

`brew link --force` creates a warning in `brew doctor` to let both you and maintainers know that link exists and could be causing issues. If you’ve linked something and there’s no problems at all? Feel free to ignore the `brew doctor` error.

## How do I use those tools outside of Homebrew?

Useful, reliable alternatives exist should you wish to use `keg_only` tools outside of Homebrew.

### Build flags:


You can set flags to give configure scripts or Makefiles a nudge in the right direction. An example of flag setting:

```shell
./configure --prefix=/Users/Dave/Downloads CFLAGS=-I$(brew --prefix)/opt/openssl/include LDFLAGS=-L$(brew --prefix)/opt/openssl/lib
```

An example using `pip`:

```shell
CFLAGS=-I$(brew --prefix)/opt/icu4c/include LDFLAGS=-L$(brew --prefix)/opt/icu4c/lib pip install pyicu
```

### `$PATH` modification:

You can temporarily prepend your `$PATH` with the tool’s bin directory, such as:

```shell
export PATH=$(brew --prefix)/opt/openssl/bin:$PATH
```

This will prepend that folder to your `$PATH`, ensuring any build script that searches the `$PATH` will find it first.

Changing your `$PATH` using that command ensures the change only exists for the duration of that shell session. Once you are no longer in that session, the `$PATH` reverts to the prior state.

### `pkg-config` detection:

If the tool you are attempting to build is [pkg-config](https://en.wikipedia.org/wiki/Pkg-config) aware, you can amend your `PKG_CONFIG_PATH` to find that `keg_only` utility’s `.pc` file, if it has them. Not all formulae ship with those files.

An example of that is:

```shell
export PKG_CONFIG_PATH=$(brew --prefix)/opt/openssl/lib/pkgconfig
```

If you’re curious about the `PKG_CONFIG_PATH` variable `man pkg-config` goes into more detail.

You can get `pkg-config` to detail the default search path with:

```shell
pkg-config --variable pc_path pkg-config
```
