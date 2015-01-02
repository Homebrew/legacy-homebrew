# Maintainer Guidelines
**This guide is for maintainers.** These special people have **write
access** to Homebrew’s repository and help merge the contributions of
others. You may find what is written here interesting, but it’s
definitely not a beginner’s guide.

Maybe you were looking for the [Formula Cookbook](Formula-Cookbook.md)?

## Quick Checklist

This is all that really matters:
-   Ensure the name is correct. This cannot be changed later, so it must
    be right the first time!
-   Add aliases
-   Ensure it is not a dupe of anything that comes with OS X
-   Ensure it is not a library that can be installed with
    [gem](http://en.wikipedia.org/wiki/RubyGems),
    [cpan](http://en.wikipedia.org/wiki/Cpan) or
    [pip](https://pip.pypa.io/en/latest).
-   Ensure the name is not in Ruby’s stdlib (Try
    `Formula.factory('readline')` in the `brew irb` shell)
-   Ensure that any dependencies are accurate

You should test the build process. But you’re really pressed for time,
just get it in there and let someone else test the build.

Checking deps is important, because they will probably stick around
forever. Nobody really checks if they are necessary or not. Use the
`:optional` and `:recommended` modifiers as appropriate.

Depend on as little stuff as possible. Avoid X11 functionality unless it
is required. For example, we build Wireshark, but not the monolithic
GUI. If users want that, they should just grab the DMG that Wireshark
themselves provide.

Homebrew is about UNIX software. Stuff that builds to an `.app` should
be accepted frugally. That is, rarely.

### Naming
The name is the strictest item, because we can’t change it afterwards.

Choose a name that’s the colloquial (most common) name for the project.
For example, we chose `objective-caml`, but we should have chosen `ocaml`.
Choose what people say to each other when talking about the project.

Add other names as aliases with the `aka` class function. Ensure the
name referenced on the homepage is one of these, as it may be different
and have underscores and hyphens and so on.

We don’t allow versions in formula names (e.g. `bash4.rb`). This is
sometimes frustrating, but we’re trying to solve this properly.
(`python3.rb` is a rare exception, because it’s basically a “new”
language and installs no conflicting executables.)

For now, if someone submits a formula like this, we’ll leave them in
their own tree.

### Merging, rebasing, cherry-picking
Merging is mainly useful when new work is being done. Please `rebase` or
cherry-pick contributions rather than fill our tree up with noisy merge
commits.

Don’t `rebase` until you finally `push`. Once pushed, you can’t `rebase`
: **you’re a maintainer now!**

Cherry-picking changes the date of the commit, which kind of sucks.

Don’t `merge` unclean branches. So if someone is still learning `git`
their branch is filled with nonsensical merges, then `rebase` and squash
the commits. Our main branch history should be useful to other people,
not confusing.

### Testing
We need to at least check it builds. Use [Brew Test Bot](Brew-Test-Bot.md) for this.

Verify the formula works if possible. If you can’t tell—for example, if
it’s a library—trust the original contributor, it worked for them, so
chances are it is fine. If you aren’t an expert in the tool in question,
you can’t really gauge if the formula installed the program correctly.
At some point an expert will come along, cry blue murder that it doesn’t
work, and fix it. This is how open source works.
Ideally, request a `test do` block to test that functionality is consistently available.

If the formula uses a repository, then the `url` parameter should have a
tag or revision. `url` s have versions and are stable (not yet
implemented!).

### Testing in `/usr/local` and somewhere else
If not completely annoying, test in both `/usr/local` and somewhere
else. Preferably on different machines to ensure the `/usr/local`
install doesn’t effect the other one.

The reason for this is some build systems suck, and fail if deps aren’t
installed in `/usr/local`, even though Homebrew goes to some lengths to
try to make this work.

## Common “Gotchas”
1.  [Ensure you have set your username and email address
    properly](http://help.github.com/git-email-settings/)
2.  Sign off cherry-picks if you amended them, [GitX-dev](https://github.com/rowanj/gitx) can do this,
    otherwise there is a command line flag for it)
3.  If the commit fixes a bug, use “Fixes \#104” syntax to close the bug
    report and link to the commit

### Build “Gotchas”
Often parallel builds work with 2-core systems, but fail on 4-core
systems.

### Dupes
The main branch avoids dupes as much as possible. The exception is
libraries that OS X provides but have bugs, and the bugs are fixed in a
newer version. Or libraries that OS X provides, but they are too old for
some other formula.

Still determine if it possible to avoid the dupe. Be thorough. Duped
libs and tools cause bugs that are tricky to solve. Once the formula is
pulled, we can’t go back on that willy-nilly.

If it dupes anything ask another contributor first. Some dupes are okay,
some can cause subtle issues we don’t want to have to deal with in the
future.

Dupes we have allowed:
-   `libxml` \<— OS X version is old and buggy
-   `libpng` \<— Ditto

#### Add comments!
It may be enough to refer to an issue ticket, but make sure changes that
if you came to them unaware of the surrounding issues would make sense
to you. Many times on other projects I’ve seen code removed because the
new guy didn’t know why it was there. Regressions suck.

### Don’t allow bloated diffs
Amend a cherry-pick to remove commits that are only changes in
whitespace. They are not acceptable because our history is important and
`git blame` should be useful.

Whitespace corrections (to ruby standard etc.) are allowed (in fact this
is a good opportunity to do it) provided the line itself has some kind
of modification that is not whitespace in it. But be careful about
making changes to inline patches—make sure they still apply.

This rule is why the `case` statement in the `brew` tool is a mess.
We’ll fix such things up for v2.

### Moving formulae from one tap to another
And preserving the history. I made a
[gist](https://gist.github.com/samueljohn/5280700) about this, based on
Jack’s initial version.
