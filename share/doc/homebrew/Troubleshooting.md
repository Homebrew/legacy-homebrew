# Troubleshooting
## Read this first!

Please run `brew update` and `brew doctor` *before* creating an issue!

To create an issue, please run:

```
brew gist-logs -n <formula name>
```

Read on for more detailed instructions.

Thank you!

## Check for common issues
* Run `brew update` — then try again.
* Run `brew doctor` — the doctor diagnoses common issues.
* Read through the [Common Issues](Common-Issues.md) page.
* If you’re installing something Java-related, maybe you need the [Java Developer Update][] or [JDK 7][]?
* Check that **Command Line Tools for Xcode (CLT)** and/or **Xcode** are up to date.
* If things fail with permissions errors, check the permissions in `/usr/local`. If you’re unsure what to do, you can `sudo chown -R $(whoami) /usr/local`.

#### Listen to Dr. Brew

* **Update Xcode and/or Command Line Tools for Xcode!** Make sure that Xcode is up-to-date in the App Store. Check that the CLT package is up-to-date (either via Xcode, Preferences or at [Apple Developer][]).
* If `brew doctor` warns about unbrewed dylibs, be advised that they are **very likely to cause build problems**.

## Check to see if the issue has been reported
* Browse open issues on the [issue tracker](https://github.com/Homebrew/homebrew/issues) to see if someone else has already reported the same problem.
* Make sure you check issues on the correct repository. If the formula that failed to build is part of a tap, like [homebrew-science](https://github.com/Homebrew/homebrew-science) or [homebrew-dupes](https://github.com/Homebrew/homebrew-dupes), check there instead.

#### Bug Reporting

* If you are reporting a bug rather than a build failure, please include brew config, brew doctor, and enough information to reliably reproduce the bug.

[Gist]:https://gist.github.com
[Apple Developer]:https://developer.apple.com/downloads
[Java Developer Update]:http://support.apple.com/kb/DL1572
[JDK 7]:http://docs.oracle.com/javase/7/docs/webnotes/install/mac/mac-install-faq.html
