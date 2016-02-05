# How to Create and Maintain a Tap
Taps are external sources of Homebrew formulae and/or external commands. They
can be created by anyone to provide their own formulae and/or external commands
to any Homebrew user.

## Creating a tap
A tap is usually a git repository available online, but you can use anything as
long as it’s a protocol that git understands, or even just a directory with
files in it.
If hosted on GitHub, we recommend that the repository’s name start with
`homebrew-`.

Tap formulae follow the same format as the core’s ones, and can be added at the
repository’s root, or under `Formula` or `HomebrewFormula` subdirectories. We
recommend the latter options because it makes the repository organisation
easier to grasp, and top-level files are not mixed with formulae.

See [homebrew/tex](https://github.com/Homebrew/homebrew-tex) for an example of
a tap with a `Formula` subdirectory.

### Installing
If it’s on GitHub, users can install any of your formulae with
`brew install user/repo/formula`. Homebrew will automatically add your
`github.com/user/homebrew-repo` tap before installing the formula.
`user/repo/formula` points to the `github.com/user/homebrew-repo/**/formula.rb`
file here.

If they want to get your tap without installing any formula at the same time,
users can add it with the [`brew tap` command](brew-tap.md).

If it’s on GitHub, they can use `brew tap user/repo`, where `user` is your
GitHub username and `homebrew-repo` your repository.

If it’s hosted outside of GitHub, they have to use `brew tap user/repo <url>`,
where `user` and `repo` will be used to refer to your tap and `<url>` is your
Git clone URL.

Users can then install your formulae either with `brew install foo` if there’s
no core formula with the same name, or with `brew install user/repo/foo` to
avoid conflicts.

## Maintaining a tap
A tap is just a git repository so you don’t have to do anything specific when
making modifications apart from committing and pushing your changes.

### Updating
Once your tap installed, Homebrew will update it each time an user runs
`brew update`. Outdated formulae will be upgraded when an user runs
`brew upgrade`, like core formulae.

## External commands
You can provide your tap users with custom `brew` commands by adding them in a
`cmd` subdirectory. [Read more on external commands](External-Commands.md).

See [homebrew/aliases](https://github.com/Homebrew/homebrew-aliases) for an
example of a tap with external commands.
