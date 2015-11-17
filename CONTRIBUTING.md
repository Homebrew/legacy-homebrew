# Contributing to Linuxbrew
[Linuxbrew](https://github.com/Homebrew/linuxbrew) is a fork of [Homebrew](https://github.com/Homebrew/homebrew). Homebrew is merged into Linuxbrew roughly once per week. If you wish to contribute a new formula, a new version of an existing formula, or any other change that is not specific to Linux, please send your pull request to Homebrew rather than to Linuxbrew.

Patches to fix issues particular to Linux should not affect the behaviour of the formula on Mac. Use `if OS.mac?` and `if OS.linux?` as necessary to preserve the existing behaviour on Mac.

# Contributing to Homebrew
## Reporting Bugs
First, please run `brew update` and `brew doctor`.

Second, read the [Troubleshooting Checklist](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Troubleshooting.md#troubleshooting).

**If you don't read these it will take us far longer to help you with your problem.**

## Security
Please report security issues to security@brew.sh.

## Contributing
Please read:

* [Code of Conduct](https://github.com/Homebrew/homebrew/blob/master/CODEOFCONDUCT.md#code-of-conduct)
* [Formula Cookbook](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md#formula-cookbook)
* [Acceptable Formulae](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Acceptable-Formulae.md#acceptable-formulae)
* [Ruby Style Guide](https://github.com/styleguide/ruby)
* [How To Open a Homebrew Pull Request (and get it merged)](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/How-To-Open-a-Homebrew-Pull-Request-(and-get-it-merged).md#how-to-open-a-homebrew-pull-request-and-get-it-merged)

Thanks!
