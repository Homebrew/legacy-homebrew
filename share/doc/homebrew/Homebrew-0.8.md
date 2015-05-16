# Homebrew 0.8
On March 12, 2011, the "refactor" branch was merged into trunk, and Homebrew bumped to version 0.8.

The major user-visible change in this version is that all Homebrew commands have been split out into separate ruby files, in the "Library/Homebrew/cmd" folder. Adding a new core command now means adding a new file to the "cmd" folder, following the same pattern as in other files.

In addition, external commands can now override core commands, so if you have an executable "brew-remove.rb" in your path ahead of "brew", that version of "remove" will be used instead of the core command. **Please use caution when using this feature** as we can't help you diagnose other build problems if you override built-in commands. This feature is meant for deep tinkering, and trying out new features without modifying core directly.

The guts of Homebrew, utility modules and whatnot, have also been reorganized and cleaned up, for the better we think. Xcode detection in particular has been redone, which should make it easier to support Xcode 4 / Lion, which is a very high priority for the project.

Also pushed with this release is some improvements in support for Fortran-based projects, including "R".

### Formula acceptance policy
Homebrew still tries not to duplicate system-provided functionality. There are cases, especially in order to support Leopard, where newer versions of system-provided software is duplicated in Homebrew, but we are trying to be tougher on accepting duplicates.

Software that requires patching to build on OS X is OK, but patches should (A) be properly sourced and documented and (B) every attempt should be made to get the upstream project to take the OS X patch upstream. MacPorts is a useful starting point for patches, but remember that they often patch more heavily than Homebrew-based formulae need to (often not submitting patches upstream), so do try to create a minimal version of any patch sourced from MacPorts.

### External Repos
Note that Homebrew (prior to 0.8) can install brews from URLs and absolute path names, so it is no longer necessary for all brews to live in the core Library. The previous "duplicates" branch maintained by adamv has been deprecated and replaced with the [Homebrew-Alt](https://github.com/adamv/homebrew-alt) repository.

Homebrew-Alt has a more liberal formula acceptance policy, and we may direct pull requests to this repository instead in some cases.

### Issues
If you do have Xcode 4 installed, and brews are failing due to llvm-gcc, there are new "--use-gcc" and "HOMEBREW_USE_GCC" flags to force use of GCC 4.2 while we work on an integrated solution.

If you have modified core Homebrew files, chances are this change won't merge or rebase cleanly for you. We apologize for this, but feel that it was important to do a "big bang cleanup" prior to any "1.0" release.

### The Future
The future is unwritten.

But current priorities include:

* Proper Xcode 4 support, along with maintaining Xcode 3.2.x support for the time being
* Proper Lion support, when it releases, including handling its new and updated system-provided libraries
* Multi-repo support, to allow file-only repos including dependency resolution

Other avenues of exploration include:

* Providing (mostly) stable textual outputs on some commands, like git does, so external tools can have stable outputs to parse
