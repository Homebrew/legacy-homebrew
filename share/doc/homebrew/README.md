# README
Homebrew installs the stuff you need that Apple didn’t.

-   [Install Homebrew](Installation.md)
-   [FAQ](FAQ.md)
-   [Tips n' Tricks](Tips-N'-Tricks.md)
-   [Gems, Eggs and Perl Modules](Gems,-Eggs-and-Perl-Modules.md) and [Homebrew and Python](Homebrew-and-Python.md)

Please note: Homebrew is not 1.0 yet. Generally it works well, but when
it doesn’t we’d hope you report the bug. If it’s still broken at 1.0 you
have our permission to throw a strop and make a big fuss.

## Troubleshooting
First, please run `brew update` and `brew doctor`.

Second, please read the [Troubleshooting Checklist](Troubleshooting.md).

**If you don’t read these it will take us far longer to help you with
your problem.**

However! Fixing build issues is easier than you think: try
`brew edit $FORMULA` and see how you fare.

## Contributing
In short:

1.  [Fork Homebrew](https://github.com/Homebrew/homebrew/fork).
2.  `brew create https://example.com/foo-0.1.tar.gz`
3.  `git checkout -b foo`
4.  `git commit Library/Formula/foo.rb && git push`
5.  [Pull Request](https://github.com/Homebrew/homebrew/pulls).

In long:

-   [Formula Cookbook](Formula-Cookbook.md)
-   [Acceptable Formulae](Acceptable-Formulae.md)
-   [Ruby Style Guide](https://github.com/styleguide/ruby)

### Community Forums
-   [@MacHomebrew](https://twitter.com/MacHomebrew)
-   [homebrew@librelist.com](mailto:homebrew@librelist.com)
    ([archive](http://librelist.com/browser/homebrew))
-   [freenode.net\#machomebrew](irc://irc.freenode.net/#machomebrew)

## News
-   [Homebrew 0.9.3](Homebrew-0.9.3.md) Superenv is here to save the day.
-   [Homebrew 0.9](Homebrew-0.9.md) `brew-tap` lands.
-   [Homebrew 0.8](Homebrew-0.8.md) has been released, including the “refactor” branch
    and some improved support for Fortran-based software.

## Supporters
[A list of the awesome people who gave £5 or more to our
Kickstarter](https://github.com/Homebrew/homebrew/blob/master/SUPPORTERS.md).
