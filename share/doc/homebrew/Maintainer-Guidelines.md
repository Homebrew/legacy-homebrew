# Maintainer Guidelines
**This guide is for maintainers.** These special people have **write
access** to Homebrew’s repository and help merge the contributions of
others. You may find what is written here interesting, but it’s
definitely not a beginner’s guide.

Maybe you were looking for the [Formula Cookbook](Formula-Cookbook.md)?

----

Quick links:
  [General Guidelines](#general-guidelines) •
  [Core and Core PRs](#core-and-core-prs) •
  [Formulae and Formula PRs](#formulae-and-formula-prs)

## General Guidelines

## Quick Checklist
1.  [Ensure you have set your username and email address
    properly](https://help.github.com/articles/setting-your-email-in-git/).
2.  Sign off cherry-picks if you amended them
    ([GitX-dev](https://github.com/rowanj/gitx) can do this, otherwise there is
    a command line flag for it).
3.  If the commit fixes a bug, use “Fixes \#104” syntax to close the bug
    report and link to the commit.

### Add Comments
It may be enough to refer to an issue ticket, but make sure changes that would
make sense to you, if you came to them unaware of the surrounding issues. Many
times on other projects I’ve seen code removed because the new guy didn’t know
why it was there. Regressions suck.

### Merging, Rebasing, Cherry-Picking
Merging is mainly useful when new work is being done. Please use `brew pull`
(or `rebase`/`cherry-pick` contributions) rather than fill Homebrew's Git
history up with noisy merge commits.

Don’t `rebase` until you finally `push`. Once `master` is pushed, you can’t
`rebase`: **you’re a maintainer now!**

Cherry-picking changes the date of the commit, which kind of sucks.

Don’t `merge` unclean branches. So if someone is still learning `git`
their branch is filled with nonsensical merges, then `rebase` and squash
the commits. Our main branch history should be useful to other people,
not confusing.

### Don’t Allow Bloated Diffs
Amend a cherry-pick to remove commits that are only changes in
whitespace. They are not acceptable because our history is important and
`git blame` should be useful.

Whitespace corrections (to Ruby standard etc.) are allowed (in fact this
is a good opportunity to do it) provided the line itself has some kind
of modification that is not whitespace in it. But be careful about
making changes to inline patches—make sure they still apply.

## Core and Core PRs

### Quick Checklist
- Bug fixes:
  - Make sure to use the “Fixes \#1337” syntax to close the bug report and
    link to the commit.
  - If not urgent, consider creating a PR to facilitate feedback and enable testing via CI.
- New features and major changes:
  - Always create a PR.
  - Try to motivate your changes (the **why**, the **what** is usually evident from
    the code).
  - Facilitate feedback by labeling the PR with “[maintainer feedback](https://github.com/Homebrew/homebrew/labels/maintainer%20feedback)” and/or mentioning domain experts in a “cc” line.
- Ensure the added/changed code is covered by tests (`brew tests --coverage`)
  and passes them.
- Thank people for contributing.

### Testing
Unlike most formulae changes, code that ends up in core immediately affects all
our users. Testing and improving our test coverage is therefore vital to avoid
breaking users’ installations.
(See [#46994](https://github.com/Homebrew/homebrew/issues/46994) for the
original discussion.)

Use `brew tests --coverage` to run tests and generate a coverage report, then
`open $(brew --repo)/Library/Homebrew/test/coverage/index.html` for inspection.

Bug fixes (can be omitted/postponed for urgent fixes):

1. Create a (failing) test that exposes the bug.
2. Fix the bug.
3. Check that the test now succeeds and none of the preexisting tests fail.

New features and major changes:

1. Look at the coverage of the code you wish to modify and see if it’s covered
   by existing tests.
2. If necessary, add new (passing) tests to cover the code you wish to modify.
3. Add/modify the code.
4. Ensure all tests still pass and write new tests to cover added code.

Code refactorings:

1. Treat them like new features and major changes.
2. Additionally, consider reviewing existing tests and making better testability
   another goal of the refactoring (avoid global state, separate concerns,
   decouple user-input handling from functionality, etc.).

## Formulae and Formula PRs

### Quick Checklist
This is all that really matters for a new formula:
- Ensure the name is correct.
- Add aliases.
- Ensure it is not a duplicate of anything that comes with OS X.
- Ensure it is not a library that can be installed with
  [gem](https://en.wikipedia.org/wiki/RubyGems),
  [cpan](https://en.wikipedia.org/wiki/Cpan) or
  [pip](https://pip.pypa.io/en/stable/).

This is important for both new formulae and version bumps:
- Ensure that any dependencies are accurate and minimal. We don't need to
  support every possible optional feature for the software.
- Use `brew pull` when possible to add messages to auto-close pull requests (which may take ~5m, be patient) and pull bottles built by [Brew Test Bot](Brew-Test-Bot-For-Core-Contributors.md).
- Thank people for contributing.

Checking dependencies is important, because they will probably stick around
forever. Nobody really checks if they are necessary or not. Use the
`:optional` and `:recommended` modifiers as appropriate.

Depend on as little stuff as possible. Disable X11 functionality by default.
For example, we build Wireshark, but not the monolithic GUI. If users want
that, they should just grab the DMG that Wireshark themselves provide.

Homebrew is about Unix software. Stuff that builds to an `.app` should
probably be in Homebrew Cask instead.

### Naming
The name is important as it helps users find what they are looking for. It can
be changed afterwards, but getting it right from the start should be the goal.

Choose a name that’s the most common name for the project.
For example, we chose `objective-caml`, but we should have chosen `ocaml`.
(This has been rectified nowadays thanks to formula renames.)
Choose what people say to each other when talking about the project.

Add other names as aliases as symlinks in `Library/Aliases`. Ensure the name
referenced on the homepage is one of these, as it may be different and have
underscores and hyphens and so on.

We don’t allow versions in formula names (e.g. `bash4.rb`); these should be in
the `homebrew/versions` tap. This is sometimes frustrating, but we’re trying to
solve this properly. (`python3.rb` is a rare exception, because it’s basically
a “new” language and installs no conflicting executables.)
For now, if someone submits a formula like this, we’ll leave them in
their own tree.

### Testing
We need to at least check it builds. Use [Brew Test Bot](Brew-Test-Bot.md) for this.

Verify the formula works if possible. If you can’t tell (e.g. if it’s a
library) trust the original contributor, it worked for them, so chances are it
is fine. If you aren’t an expert in the tool in question, you can’t really
gauge if the formula installed the program correctly. At some point an expert
will come along, cry blue murder that it doesn’t work, and fix it. This is how
open source works. Ideally, request a `test do` block to test that
functionality is consistently available.

If the formula uses a repository, then the `url` parameter should have a
tag or revision. `url`s have versions and are stable (not yet implemented!).

### Duplicates
The main repository avoids duplicates as much as possible. The exception is
libraries that OS X provides but have bugs, and the bugs are fixed in a
newer version. Or libraries that OS X provides, but they are too old for
some other formula. The rest should be in the `homebrew/dupes` tap.

Still determine if it possible to avoid the duplicate. Be thorough. Duplicated
libraries and tools cause bugs that are tricky to solve. Once the formula is
pulled, we can’t go back on that willy-nilly.

If it duplicates anything ask another maintainer first. Some duplicates are okay,
some can cause subtle issues we don’t want to have to deal with in the future.

Duplicates we have allowed:
- `libxml` – OS X version is old and buggy
- `libpng` – Ditto
