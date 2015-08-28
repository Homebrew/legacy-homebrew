# Tips N' Tricks

## Installing previous versions of formulae

The preferred and supported method of installing specific versions of
formulae is to use the
[Homebrew-versions](https://github.com/Homebrew/homebrew-versions)
tap.  If the version you’re looking for isn’t available, consider [opening a
pull request](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/How-To-Open-a-Homebrew-Pull-Request-(and-get-it-merged).md)!

### Installing directly from pull-requests

You can browse pull requests https://github.com/Homebrew/homebrew/pulls
and install through the direct link. For example Python 3.3.0 pull request https://github.com/Homebrew/homebrew/pull/15199

```sh
brew install https://raw.github.com/dsr/homebrew/9b22d42f50fcbc5e52c764448b3ac002bc153bd7/Library/Formula/python3.rb
```

## Quickly remove something from /usr/local

```sh
brew unlink $FORMULA
```

This can be useful if a package can't build against the version of something you have linked into `/usr/local`.

And of course, you can simply `brew link $FORMULA` again afterwards!

## Install into Homebrew without formulas

```sh
./configure --prefix=/usr/local/Cellar/foo/1.2 && make && make install && brew link foo
```

## Command tab-completion

### Bash
Add to your `~/.bashrc` or `~/.bash_profile` (whichever you have configured to run on shell startup):

```bash
source $(brew --repository)/Library/Contributions/brew_bash_completion.sh
```

### Zsh
Run in terminal (may require `sudo`):

```zsh
ln -s "$(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh" /usr/local/share/zsh/site-functions
```

## Pre-downloading a file for a formula

Sometimes it's faster to download a file via means other than those
strategies that are available as part of Homebrew.  For example,
Erlang provides a torrent that'll let you download at 4–5× the normal
HTTP method.

Download the file and drop it in `~/Library/Caches/Homebrew`, but
watch the file name.  Homebrew downloads files as <code>{{ formula
name }}-{{ version }}</code>.  In the case of Erlang, this requires
renaming the file from <code>otp_src_R13B03</code> to
<code>erlang-R13B03</code>.

`brew –-cache -s erlang` will print the correct name of the cached
download.  This means instead of manually renaming a formula, you can
run `mv the_tarball $(brew --cache -s $FORMULA)`.

You can also pre-cache the download by using the command `brew fetch formula` which also displays the SHA1 and SHA256 values. This can be useful for updating formulae to new versions.

## Using Homebrew behind a proxy

Behind the scenes, Homebrew uses several commands for downloading files (e.g. curl, git, svn).  Many of these tools can download via a proxy.  It's a common (though not universal) convention for these command-line tools to observe getting the proxy parameters from environment variables (e.g. `http_proxy`).  Unfortunately, most tools are inconsistent in their use of these environment parameters (e.g. curl supports `http_proxy`, `HTTPS_PROXY`, `FTP_PROXY`, `GOPHER_PROXY`, `ALL_PROXY`, `NO_PROXY`).

Luckily, for the majority of cases setting `http_proxy` is enough.
You can set this environment variable in several ways (search on the
internet for details), including at runtime:

```
http_proxy=http://<proxyhost>:<proxyport> brew install $FORMULA
```

### Proxy Authentication

```sh
http_proxy=http://<user>:<password>@<proxyhost>:<proxyport>  brew install $FORMULA
```

## Installing stuff without the Xcode-CLT

```sh
$ brew sh          # or: eval $(brew --env)
$ gem install ronn # or c-programs
```

This imports the brew environment into your existing shell, gem will pick up the environment variables and be able to build. As a bonus brew's automatically determined optimization flags are set.

## Install only a formula's dependencies (not the formula)

```sh
brew install --only-dependencies $FORMULA
```

## Interactive Homebrew Shell

```sh
$ brew irb
1.8.7 :001 > Formula.factory("ace").methods - Object.methods
 => [:install, :path, :homepage, :downloader, :stable, :bottle, :devel, :head, :active_spec, :buildpath, :ensure_specs_set, :url, :version, :specs, :mirrors, :installed?, :explicitly_requested?, :linked_keg, :installed_prefix, :prefix, :rack, :bin, :doc, :include, :info, :lib, :libexec, :man, :man1, :man2, :man3, :man4, :man5, :man6, :man7, :man8, :sbin, :share, :etc, :var, :plist_name, :plist_path, :download_strategy, :cached_download, :caveats, :options, :patches, :keg_only?, :fails_with?, :skip_clean?, :brew, :std_cmake_args, :deps, :external_deps, :recursive_deps, :system, :fetch, :verify_download_integrity, :fails_with_llvm, :fails_with_llvm?, :std_cmake_parameters, :mkdir, :mktemp]
1.8.7 :002 >
```

## Hiding the beer mug emoji when finishing a build

```sh
export HOMEBREW_NO_EMOJI=1
```

This sets the HOMEBREW_NO_EMOJI environment variable, causing Homebrew
to hide all emoji.

The beer emoji can also be replaced with other character(s):

```sh
export HOMEBREW_INSTALL_BADGE="☕️ 🐸"
```

## Editor plugins

### Sublime Text

In Sublime Text 2/3, you can use Package Control to install
[Homebrew-formula-syntax](https://github.com/samueljohn/Homebrew-formula-syntax),
which adds highlighting for inline patches.

### Vim

[brew.vim](https://github.com/xu-cheng/brew.vim) adds highlighting to
inline patches in Vim.

### Emacs

[homebrew-mode](https://github.com/dunn/homebrew-mode) provides syntax
highlighting for inline patches as well as a number of helper functions
for editing formula files.
