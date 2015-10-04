# Troubleshooting
**If you saw `Error: uninitialized constant Formulary::HOMEBREW_CORE_FORMULA_REGEX. Please report this bug: ...` don't worry: it's [already been fixed](https://github.com/Homebrew/homebrew/commit/ac5707c37470c25583d8fb712bf5dc04ab91db4b). Please only create an issue (or comment on [the existing one](https://github.com/Homebrew/homebrew/issues/42553)) if running `brew update` again doesn't fix it. Thanks!**

## Read this first!

Please run `brew update` and `brew doctor` *before* creating an issue!

If you create an issue related to a formula, please also create a [Gist][] by running

```
brew gist-logs <formula name>
```

and include a link to the gist in the issue.

Read on for more detailed instructions.

Thank you!

## Check for common issues
* Run `brew update` — then try again.
* Run `brew doctor` — the doctor diagnoses common issues.
* Read through the [Common Issues](Common-Issues.md) page.
* If you’re installing something Java-related, maybe you need the [Java Developer Update][] or [JDK 7][]?
* Check that **Command Line Tools for Xcode (CLT)** and/or **Xcode** are up to date.
* If things fail with permissions errors, check the permissions in `/usr/local`. If you’re unsure what to do, you can `sudo chown -R $(whoami) /usr/local`.
* If you see permission errors after upgrading to El Capitan please see the [El Capitan and Homebrew](El_Capitan_and_Homebrew.md) document.

#### Listen to Dr. Brew

* **Update Xcode and/or Command Line Tools for Xcode!** Make sure that Xcode is up-to-date in the App Store. Check that the CLT package is up-to-date (either via Xcode, Preferences or at [Apple Developer][]).
* If `brew doctor` warns about unbrewed dylibs, be advised that they are **very likely to cause build problems**.

## Check to see if the issue has been reported
* Browse open issues on the [issue tracker](https://github.com/Homebrew/homebrew/issues) to see if someone else has already reported the same problem.
* Make sure you check issues on the correct repository. If the formula that failed to build is part of a tap, like [homebrew-science](https://github.com/Homebrew/homebrew-science) or [homebrew-dupes](https://github.com/Homebrew/homebrew-dupes), check there instead.

## Create an issue

1. [Create a new issue](https://github.com/Homebrew/homebrew/issues/new)
  * Again, make sure you file the issue against the correct repository.
  * If you are reporting a build failure, title it "\<formula name> failed to build on 10.x", where \<formula name> is the name of the formula that failed to build, and 10.x is the version of OS X you are using.
  * Otherwise, choose a title that best describes the problem you are experiencing.

2. Upload a [Gist][] with relevant debugging information
  * The simplest method is to run `brew gist-logs <formula name>`
  * You can also create a [Gist][] manually. Include the following:
     1. The output from `HOMEBREW_MAKE_JOBS=1 brew install -v <formula name> 2>&1`
     2. The contents of the largest numbered log in `~/Library/Logs/Homebrew/<formula name>`, e.g. `03.make`
     3. The output from `brew config` and `brew doctor`
  * If you are reporting a bug rather than a build failure, please include `brew config`, `brew doctor`, and enough information to reliably reproduce the bug.

3. Include a link to the gist in your new issue
  * Be sure to use the `https:` URL (i.e. the URL in your browser's address bar), not the `git:` URL.

[Gist]:https://gist.github.com
[Apple Developer]:https://developer.apple.com/downloads
[Java Developer Update]:https://support.apple.com/kb/DL1572
[JDK 7]:https://docs.oracle.com/javase/7/docs/webnotes/install/mac/mac-install-faq.html
