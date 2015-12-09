# Contributing to Homebrew
First time contributing to Homebrew? Read our [Code of Conduct](https://github.com/Homebrew/homebrew/blob/master/CODEOFCONDUCT.md#code-of-conduct).

To report a bug:

- run `brew update` (twice), run and read `brew doctor`, read [the Troubleshooting Checklist](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Troubleshooting.md#troubleshooting), open an issue on the formula's repository.

Submit a `1.2.3` version upgrade for the `foo` formula:

- `brew edit foo`, edit [`url`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#url-class_method) and [`sha256`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#sha256%3D-class_method)/[`tag`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#url-class_method), leave the [`bottle`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#bottle-class_method) as-is, `brew install foo`, `git commit` with commit subject `foo 1.2.3`, [open a pull request](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/How-To-Open-a-Homebrew-Pull-Request-(and-get-it-merged).md#how-to-open-a-homebrew-pull-request-and-get-it-merged) and fix any failing tests.

To add a new formula for `foo` version `2.3.4` from `$URL`:

- Read [the Formula Cookbook](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md#formula-cookbook) or: `brew create $URL` and make edits, `brew install foo`, `brew audit --online --strict foo`, `git commit` with message formatted `foo 2.3.4 (new formula)`, [open a pull request](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/How-To-Open-a-Homebrew-Pull-Request-(and-get-it-merged).md#how-to-open-a-homebrew-pull-request-and-get-it-merged) and fix any failing tests.

To contribute a fix to the `foo` formula:

- `brew edit foo` and make edits, leave the [`bottle`](http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula#bottle-class_method) as-is, `brew install foo`, `git commit` with message formatted `foo: fix <insert details>.`, [open a pull request](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/How-To-Open-a-Homebrew-Pull-Request-(and-get-it-merged).md#how-to-open-a-homebrew-pull-request-and-get-it-merged) and fix any failing tests.

To report a security vulnerability:

- [Email security@brew.sh](mailto:security@brew.sh) (a private mailing list) with detailed reproduction instructions using [our PGP key](https://keybase.io/homebrew/key.asc).

Thanks!
