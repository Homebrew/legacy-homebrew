require 'formula'

# This is not a gzipped tarball and Homebrew won't extract it automaticaly
class CustomDownloadStrategy < CurlDownloadStrategy
  def stage
    safe_system '/usr/bin/tar', 'xf', @tarball_path
    chdir
  end
end

class Darcs <Formula
  homepage 'http://darcs.net'
  url 'http://darcs.net/binaries/macosx/darcs-2.5-OSX-10.6-i386.tar.gz', :using => CustomDownloadStrategy
  version '2.5'
  md5 'd9d6c05463846f9b4cf9386ea714cb16'

  def install
    # Building from source requires GHC, which needs forever to bootstrap and build, so the official binary is used.
    bin.install 'darcs'
    # A man page is definitely necessary for this software, but I cannot find separate download of the man page, so I included it in the formula.
    (man1/'darcs.1').write DATA.read
  end
end


__END__
.TH DARCS 1 "2.5 (release)"
.SH NAME
darcs \- an advanced revision control system
.SH SYNOPSIS
.B darcs
.I command
.RI < arguments |[ options ]>...

Where the
.I commands
and their respective
.I arguments
are

.B darcs help
.RI "[<" "darcs" "_" "command" "> [" "darcs" "_" "subcommand" "]]  "
.br
.B darcs add
.RI "<" "file" "|" "directory" "> ..."
.br
.B darcs remove
.RI "<" "file" "|" "directory" "> ..."
.br
.B darcs move
.RI "<" "source" "> ... <" "destination" ">"
.br
.B darcs replace
.RI "<" "old" ">"
.RI "<" "new" ">"
.RI "<" "file" "> ..."
.br
.B darcs revert
.RI "[" "file" "|" "directory" "]..."
.br
.B darcs unrevert
.br
.B darcs whatsnew
.RI "[" "file" "|" "directory" "]..."
.br
.B darcs record
.RI "[" "file" "|" "directory" "]..."
.br
.B darcs unrecord
.br
.B darcs amend-record
.RI "[" "file" "|" "directory" "]..."
.br
.B darcs mark-conflicts
.br
.B darcs tag
.RI "[" "tagname" "]"
.br
.B darcs setpref
.RI "<" "pref" ">"
.RI "<" "value" ">"
.br
.B darcs diff
.RI "[" "file" "|" "directory" "]..."
.br
.B darcs changes
.RI "[" "file" "|" "directory" "]..."
.br
.B darcs annotate
.RI "[" "file" "|" "directory" "]..."
.br
.B darcs dist
.br
.B darcs trackdown
.RI "[[" "initialization" "]"
.RI "command" "]"
.br
.B darcs show contents
.RI "[" "file" "]..."
.br
.B darcs show files
.RI "[" "file" "|" "directory" "]..."
.br
.B darcs show index
.br
.B darcs show pristine
.br
.B darcs show repo
.br
.B darcs show authors
.br
.B darcs show tags
.br
.B darcs pull
.RI "[" "repository" "]..."
.br
.B darcs fetch
.RI "[" "repository" "]..."
.br
.B darcs obliterate
.br
.B darcs rollback
.RI "[" "file" "|" "directory" "]..."
.br
.B darcs push
.RI "[" "repository" "]"
.br
.B darcs send
.RI "[" "repository" "]"
.br
.B darcs apply
.RI "<" "patchfile" ">"
.br
.B darcs get
.RI "<" "repository" ">"
.RI "[<" "directory" ">]"
.br
.B darcs put
.RI "<" "new" " " "repository" ">"
.br
.B darcs initialize
.br
.B darcs optimize
.br
.B darcs check
.br
.B darcs repair
.br
.B darcs convert
.RI "<" "source" ">"
.RI "[<" "destination" ">]"
.br

.SH DESCRIPTION
Darcs is a free, open source revision control
system. It is:
.TP 3
\(bu
Distributed: Every user has access to the full
command set, removing boundaries between server and
client or committer and non\(hycommitters.
.TP
\(bu
Interactive: Darcs is easy to learn and efficient to
use because it asks you questions in response to
simple commands, giving you choices in your work
flow. You can choose to record one change in a file,
while ignoring another. As you update from upstream,
you can review each patch name, even the full `diff'
for interesting patches.
.TP
\(bu
Smart: Originally developed by physicist David
Roundy, darcs is based on a unique algebra of
patches.
This smartness lets you respond to changing demands
in ways that would otherwise not be possible. Learn
more about spontaneous branches with darcs.
.SH OPTIONS
Different options are accepted by different Darcs commands.
Each command's most important options are listed in the
.B COMMANDS
section.  For a full list of all options accepted by
a particular command, run `darcs
.I command
\-\-help'.
.SS Selecting Patches:

The \-\-patches option yields patches with names matching an `extended'
regular expression.  See regex(7) for details.  The \-\-matches option
yields patches that match a logical (Boolean) expression: one or more
primitive expressions combined by grouping (parentheses) and the
complement (not), conjunction (and) and disjunction (or) operators.
The C notation for logic operators (!, && and ||) can also be used.

 \-\-patches=regex is a synonym for \-\-matches='name regex'
 \-\-from\-patch and \-\-to\-patch are synonyms for \-\-from\-match='name... and \-\-to\-match='name...
 \-\-from\-patch and \-\-to\-match can be unproblematically combined:
 darcs changes \-\-from\-patch='html.*documentation' \-\-to\-match='date 20040212'

The following primitive Boolean expressions are supported:
  exact \- check a literal string against the patch name.
  name \- check a regular expression against the patch name.
  author \- check a regular expression against the author name.
  hunk \- check a regular expression against the contents of a hunk patch.
  comment \- check a regular expression against the log message.
  hash \- match the darcs hash for a patch.
  date \- match the patch date.
  touch \- match file paths for a patch.

Here are some examples:
  darcs annotate \-\-summary \-\-match 'exact "Resolve issue17: use dynamic memory allocation."'
  darcs annotate \-\-summary \-\-match 'name issue17'
  darcs annotate \-\-summary \-\-match 'name "^[Rr]esolve issue17\\>"'
  darcs annotate \-\-summary \-\-match 'author "David Roundy"'
  darcs annotate \-\-summary \-\-match 'author droundy'
  darcs annotate \-\-summary \-\-match 'author droundy@darcs.net'
  darcs annotate \-\-summary \-\-match 'hunk "foo = 2"'
  darcs annotate \-\-summary \-\-match 'hunk "^instance .* Foo where$"'
  darcs annotate \-\-summary \-\-match 'comment "prevent deadlocks"'
  darcs annotate \-\-summary \-\-match 'hash 20040403105958\-53a90\-c719567e92c3b0ab9eddd5290b705712b8b918ef'
  darcs annotate \-\-summary \-\-match 'date "2006\-04\-02 22:41"'
  darcs annotate \-\-summary \-\-match 'date "tea time yesterday"'
  darcs annotate \-\-summary \-\-match 'touch src/foo.c'
  darcs annotate \-\-summary \-\-match 'touch src/'
  darcs annotate \-\-summary \-\-match 'touch "src/*.(c|h)"'

.SH COMMANDS
.B darcs help
.RI "[<" "darcs" "_" "command" "> [" "darcs" "_" "subcommand" "]]  "
.RS 4
Without arguments, `darcs help' prints a categorized list of darcs
commands and a short description of each one.  With an extra argument,
`darcs help foo' prints detailed help about the darcs command foo.

.RE
.SS "Changing and querying the working copy:"
.B darcs add
.RI "<" "file" "|" "directory" "> ..."
.RS 4
Generally a repository contains both files that should be version
controlled (such as source code) and files that Darcs should ignore
(such as executables compiled from the source code).  The `darcs add'
command is used to tell Darcs which files to version control.

When an existing project is first imported into a Darcs repository, it
is common to run `darcs add \-r *' or `darcs record \-l' to add all
initial source files into darcs.

Adding symbolic links (symlinks) is not supported.

Darcs will ignore all files and folders that look `boring'.  The
\-\-boring option overrides this behaviour.

Darcs will not add file if another file in the same folder has the
same name, except for case.  The \-\-case\-ok option overrides this
behaviour.  Windows and OS X usually use filesystems that do not allow
files a folder to have the same name except for case (for example,
`ReadMe' and `README').  If \-\-case\-ok is used, the repository might be
unusable on those systems!

The \-\-date\-trick option allows you to enable an experimental trick to
make add conflicts, in which two users each add a file or directory
with the same name, less problematic.  While this trick is completely
safe, it is not clear to what extent it is beneficial.

.RE
.B darcs remove
.RI "<" "file" "|" "directory" "> ..."
.RS 4
The `darcs remove' command exists primarily for symmetry with `darcs
add', as the normal way to remove a file from version control is
simply to delete it from the working tree.  This command is only
useful in the unusual case where one wants to record a removal patch
WITHOUT deleting the copy in the working tree (which can be re\-added).

Note that applying a removal patch to a repository (e.g. by pulling
the patch) will ALWAYS affect the working tree of that repository.

.RE
.B darcs move
.RI "<" "source" "> ... <" "destination" ">"
.RS 4
Darcs cannot reliably distinguish between a file being deleted and a
new one added, and a file being moved.  Therefore Darcs always assumes
the former, and provides the `darcs mv' command to let Darcs know when
you want the latter.  This command will also move the file in the
working tree (unlike `darcs remove'), unless it has already been moved.

Darcs will not rename a file if another file in the same folder has
the same name, except for case.  The \-\-case\-ok option overrides this
behaviour.  Windows and OS X usually use filesystems that do not allow
files a folder to have the same name except for case (for example,
`ReadMe' and `README').  If \-\-case\-ok is used, the repository might be
unusable on those systems!

.RE
.B darcs replace
.RI "<" "old" ">"
.RI "<" "new" ">"
.RI "<" "file" "> ..."
.RS 4
In addition to line\-based patches, Darcs supports a limited form of
lexical substitution.  Files are treated as sequences of words, and
each occurrence of the old word is replaced by the new word.
This is intended to provide a clean way to rename a function or
variable.  Such renamings typically affect lines all through the
source code, so a traditional line\-based patch would be very likely to
conflict with other branches, requiring manual merging.

Files are tokenized according to one simple rule: words are strings of
valid token characters, and everything between them (punctuation and
whitespace) is discarded.  By default, valid token characters are
letters, numbers and the underscore (i.e. [A\-Za\-z0\-9_]).  However if
the old and/or new token contains either a hyphen or period, BOTH
hyphen and period are treated as valid (i.e. [A\-Za\-z0\-9_.\-]).

The set of valid characters can be customized using the \-\-token\-chars
option.  The argument must be surrounded by square brackets.  If a
hyphen occurs between two characters in the set, it is treated as a
set range.  For example, in most locales [A\-Z] denotes all uppercase
letters.  If the first character is a caret, valid tokens are taken to
be the complement of the remaining characters.  For example, [^:\\n]
could be used to match fields in the passwd(5), where records and
fields are separated by newlines and colons respectively.

If you choose to use \-\-token\-chars, you are STRONGLY encouraged to do
so consistently.  The consequences of using multiple replace patches
with different \-\-token\-chars arguments on the same file are not well
tested nor well understood.

By default Darcs will refuse to perform a replacement if the new token
is already in use, because the replacements would be not be
distinguishable from the existing tokens.  This behaviour can be
overridden by supplying the \-\-force option, but an attempt to `darcs
rollback' the resulting patch will affect these existing tokens.

Limitations:

The tokenizer treats files as byte strings, so it is not possible for
\-\-token\-chars to include multi\-byte characters, such as the non\-ASCII
parts of UTF\-8.  Similarly, trying to replace a `high\-bit' character
from a unibyte encoding will also result in replacement of the same
byte in files with different encodings.  For example, an acute a from
ISO 8859\-1 will also match an alpha from ISO 8859\-7.

Due to limitations in the patch file format, \-\-token\-chars arguments
cannot contain literal whitespace.  For example, [^ \\n\\t] cannot be
used to declare all characters except the space, tab and newline as
valid within a word, because it contains a literal space.

Unlike POSIX regex(7) bracket expressions, character classes (such as
[[:alnum:]]) are NOT supported by \-\-token\-chars, and will be silently
treated as a simple set of characters.

.RE
.B darcs revert
.RI "[" "file" "|" "directory" "]..."
.RS 4
The `darcs revert' command discards unrecorded changes the working
tree.  As with `darcs record', you will be asked which hunks (changes)
to revert.  The \-\-all switch can be used to avoid such prompting. If
files or directories are specified, other parts of the working tree
are not reverted.

In you accidentally reverted something you wanted to keep (for
example, typing `darcs rev \-a' instead of `darcs rec \-a'), you can
immediately run `darcs unrevert' to restore it.  This is only
guaranteed to work if the repository has not changed since `darcs
revert' ran.

.RE
.B darcs unrevert
.RS 4
Unrevert is a rescue command in case you accidentally reverted
something you wanted to keep (for example, typing `darcs rev \-a'
instead of `darcs rec \-a').

This command may fail if the repository has changed since the revert
took place.  Darcs will ask for confirmation before executing an
interactive command that will DEFINITELY prevent unreversion.

.RE
.B darcs whatsnew
.RI "[" "file" "|" "directory" "]..."
.RS 4
The `darcs whatsnew' command lists unrecorded changes to the working
tree.  If you specify a set of files and directories, only unrecorded
changes to those files and directories are listed.

With the \-\-summary option, the changes are condensed to one line per
file, with mnemonics to indicate the nature and extent of the change.
The \-\-look\-for\-adds option causes candidates for `darcs add' to be
included in the summary output.  Summary mnemonics are as follows:

  `A f' and `A d/' respectively mean an added file or directory.
  `R f' and `R d/' respectively mean a removed file or directory.
  `M f \-N +M rP' means a modified file, with N lines deleted, M
  lines added, and P lexical replacements.
  `f \-> g' means a moved file or directory.

  An exclamation mark (!) as in `R! foo.c', means the hunk is known to
  conflict with a hunk in another patch.  The phrase `duplicated'
  means the hunk is known to be identical to a hunk in another patch.

By default, `darcs whatsnew' uses Darcs' internal format for changes.
To see some context (unchanged lines) around each change, use the
\-\-unified option.  To view changes in conventional `diff' format, use
the `darcs diff' command; but note that `darcs whatsnew' is faster.

This command exits unsuccessfully (returns a non\-zero exit status) if
there are no unrecorded changes.

.RE
.SS "Copying changes between the working copy and the repository:"
.B darcs record
.RI "[" "file" "|" "directory" "]..."
.RS 4
The `darcs record' command is used to create a patch from changes in
the working tree.  If you specify a set of files and directories,
changes to other files will be skipped.

Every patch has a name, an optional description, an author and a date.

The patch name should be a short sentence that concisely describes the
patch, such as `Add error handling to main event loop.'  You can
supply it in advance with the \-m option, or provide it when prompted.

The patch description is an optional block of free\-form text.  It is
used to supply additional information that doesn't fit in the patch
name.  For example, it might include a rationale of WHY the change was
necessary.  By default Darcs asks if you want to add a description;
the \-\-edit\-long\-comment and \-\-skip\-long\-comment can be used to answer
`yes' or `no' (respectively) to this prompt.  Finally, the \-\-logfile
option allows you to supply a file that already contains the patch
name (first line) and patch description (subsequent lines).  This is
useful if a previous record failed and left a darcs\-record\-0 file.

Each patch is attributed to its author, usually by email address (for
example, `Fred Bloggs <fred@example.net>').  Darcs looks in several
places for this author string: the \-\-author option, the files
_darcs/prefs/author (in the repository) and ~/.darcs/author (in your
home directory), and the environment variables $DARCS_EMAIL and
$EMAIL.  If none of those exist, Darcs will prompt you for an author
string and write it to _darcs/prefs/author.

The patch date is generated automatically.  It can only be spoofed by
using the \-\-pipe option.

If a test command has been defined with `darcs setpref', attempting to
record a patch will cause the test command to be run in a clean copy
of the working tree (that is, including only recorded changes).  If
the test fails, the record operation will be aborted.

The \-\-set\-scripts\-executable option causes scripts to be made
executable in the clean copy of the working tree, prior to running the
test.  See `darcs get' for an explanation of the script heuristic.

If your test command is tediously slow (e.g. `make all') and you are
recording several patches in a row, you may wish to use \-\-no\-test to
skip all but the final test.

.RE
.B darcs unrecord
.RS 4
Unrecord does the opposite of record in that it makes the changes from
patches active changes again which you may record or revert later.  The
working copy itself will not change.
Beware that you should not use this command if you are going to
re\-record the changes in any way and there is a possibility that
another user may have already pulled the patch.

.RE
.B darcs amend-record
.RI "[" "file" "|" "directory" "]..."
.RS 4
Amend\-record updates a `draft' patch with additions or improvements,
resulting in a single `finished' patch.  This is better than recording
the additions and improvements as separate patches, because then
whenever the `draft' patch is copied between repositories, you would
need to make sure all the extra patches are copied, too.

Do not copy draft patches between repositories, because a finished
patch cannot be copied into a repository that contains a draft of the
same patch.  If this has already happened, `darcs obliterate' can be
used to remove the draft patch.

Do not run amend\-record in repository that other developers can pull
from, because if they pull while an amend\-record is in progress, their
repository may be corrupted.

When recording a draft patch, it is a good idea to start the name with
`DRAFT:' so that other developers know it is not finished.  When
finished, remove it with `darcs amend\-record \-\-edit\-long\-comment'.
To change the patch name without starting an editor, use \-\-patch\-name.

Like `darcs record', if you call amend\-record with files as arguments,
you will only be asked about changes to those files.  So to amend a
patch to foo.c with improvements in bar.c, you would run:

    darcs amend\-record \-\-match 'touch foo.c' bar.c

It is usually a bad idea to amend another developer's patch.  To make
amend\-record only ask about your own patches by default, you can add
something like `amend\-record match David Roundy' to ~/.darcs/defaults, 
where `David Roundy' is your name. On Windows use C:/Documents And Settings/user/Application Data/darcs/defaults

.RE
.B darcs mark-conflicts
.RS 4
Darcs requires human guidance to unify changes to the same part of a
source file.  When a conflict first occurs, darcs will add both
choices to the working tree, delimited by the markers `v v v',
`* * *' and `^ ^ ^'.

However, you might revert or manually delete these markers without
actually resolving the conflict.  In this case, `darcs mark\-conflicts'
is useful to show where any unresolved conflicts.  It is also useful
if `darcs apply' is called with \-\-apply\-conflicts, where conflicts
aren't marked initially.

Any unrecorded changes to the working tree WILL be lost forever when
you run this command!  You will be prompted for confirmation before
this takes place.

This command was historically called `resolve', and this deprecated
alias still exists for backwards\-compatibility.

.RE
.SS "Direct modification of the repository:"
.B darcs tag
.RI "[" "tagname" "]"
.RS 4
The `darcs tag' command names the current repository state, so that it
can easily be referred to later.  Every `important' state should be
tagged; in particular it is good practice to tag each stable release
with a number or codename.  Advice on release numbering can be found
at http://producingoss.com/en/development\-cycle.html.

To reproduce the state of a repository `R' as at tag `t', use the
command `darcs get \-\-tag t R'.  The command `darcs show tags' lists
all tags in the current repository.

Tagging also provides significant performance benefits: when Darcs
reaches a shared tag that depends on all antecedent patches, it can
simply stop processing.

Like normal patches, a tag has a name, an author, a timestamp and an
optional long description, but it does not change the working tree.
A tag can have any name, but it is generally best to pick a naming
scheme and stick to it.

The `darcs tag' command accepts the \-\-pipe option, which behaves as
described in `darcs record'.

.RE
.B darcs setpref
.RI "<" "pref" ">"
.RI "<" "value" ">"
.RS 4
When working on project with multiple repositories and contributors,
it is sometimes desirable for a preference to be set consistently
project\-wide.  This is achieved by treating a preference set with
`darcs setpref' as an unrecorded change, which can then be recorded
and then treated like any other patch.

Valid preferences are:

  test \-\- a shell command that runs regression tests
  predist \-\- a shell command to run before `darcs dist'
  boringfile \-\- the path to a version\-controlled boring file
  binariesfile \-\- the path to a version\-controlled binaries file

For example, a project using GNU autotools, with a `make test' target
to perform regression tests, might enable Darcs' integrated regression
testing with the following command:

  darcs setpref test 'autoconf && ./configure && make && make test'

Note that merging is not currently implemented for preferences: if two
patches attempt to set the same preference, the last patch applied to
the repository will always take precedence.  This is considered a
low\-priority bug, because preferences are seldom set.

.RE
.SS "Querying the repository:"
.B darcs diff
.RI "[" "file" "|" "directory" "]..."
.RS 4
Diff can be used to create a diff between two versions which are in your
repository.  Specifying just \-\-from\-patch will get you a diff against
your working copy.  If you give diff no version arguments, it gives
you the same information as whatsnew except that the patch is
formatted as the output of a diff command

.RE
.B darcs changes
.RI "[" "file" "|" "directory" "]..."
.RS 4
The `darcs changes' command lists the patches that constitute the
current repository or, with \-\-repo, a remote repository.  Without
options or arguments, ALL patches will be listed.

When given one or more files or directories as arguments, only
patches which affect those files or directories are listed. This
includes changes that happened to files before they were moved or
renamed.

When given a \-\-from\-tag, \-\-from\-patch or \-\-from\-match, only changes
since that tag or patch are listed.  Similarly, the \-\-to\-tag,
\-\-to\-patch and \-\-to\-match options restrict the list to older patches.

The \-\-last and \-\-max\-count options both limit the number of patches
listed.  The former applies BEFORE other filters, whereas the latter
applies AFTER other filters.  For example `darcs changes foo.c
\-\-max\-count 3' will print the last three patches that affect foo.c,
whereas `darcs changes \-\-last 3 foo.c' will, of the last three
patches, print only those that affect foo.c.

Three output formats exist.  The default is \-\-human\-readable.  You can
also select \-\-context, which is the internal format (as seen in patch
bundles) that can be re\-read by Darcs (e.g. `darcs get \-\-context').

Finally, there is \-\-xml\-output, which emits valid XML... unless a the
patch metadata (author, name or description) contains a non\-ASCII
character and was recorded in a non\-UTF8 locale.

Note that while the \-\-context flag may be used in conjunction with
\-\-xml\-output or \-\-human\-readable, in neither case will darcs get be
able to read the output.  On the other hand, sufficient information
WILL be output for a knowledgeable human to recreate the current state
of the repository.

.RE
.B darcs annotate
.RI "[" "file" "|" "directory" "]..."
.RS 4
The `darcs annotate' command provides two unrelated operations.  When
called on a file, it will find the patch that last modified each line
in that file.  When called on a patch (e.g. using \-\-patch), it will
print the internal representation of that patch.

The \-\-summary option will result in a summarized patch annotation,
similar to `darcs whatsnew'.  It has no effect on file annotations.

By default, output is in a human\-readable format.  The \-\-xml\-output
option can be used to generate output for machine postprocessing.

.RE
.B darcs dist
.RS 4
The `darcs dist' command creates a compressed archive (a `tarball') in
the repository's root directory, containing the recorded state of the
working tree (unrecorded changes and the _darcs directory are
excluded).

If a predist command is set (see `darcs setpref'), that command will
be run on the tarball contents prior to archiving.  For example,
autotools projects would set it to `autoconf && automake'.

By default, the tarball (and the top\-level directory within the
tarball) has the same name as the repository, but this can be
overridden with the \-\-dist\-name option.

.RE
.B darcs trackdown
.RI "[[" "initialization" "]"
.RI "command" "]"
.RS 4
Trackdown tries to find the most recent version in the repository which
passes a test.  Given no arguments, it uses the default repository test.
Given one argument, it treats it as a test command.  Given two arguments,
the first is an initialization command with is run only once, and the
second is the test command.

Without the \-\-bisect option, trackdown does linear search starting from head,
and moving away from head.  With the \-\-bisect option, it does binary search.

Under the assumption that failure is monotonous, trackdown produces
the same result with and without \-\-bisect.  (Monotonous means that when
moving away from head, the test result changes only once from "fail" to "ok".)
If failure is not monotonous, any one of the patches that break the test is
found at random.
.RE
.B darcs show contents
.RI "[" "file" "]..."
.RS 4
Show contents can be used to display an earlier version of some file(s).
If you give show contents no version arguments, it displays the recorded
version of the file(s).

.RE
.B darcs show files
.RI "[" "file" "|" "directory" "]..."
.RS 4
The `darcs show files' command lists those files and directories in
the working tree that are under version control.  This command is
primarily for scripting purposes; end users will probably want `darcs
whatsnew \-\-summary'.

A file is `pending' if it has been added but not recorded.  By
default, pending files (and directories) are listed; the \-\-no\-pending
option prevents this.

By default `darcs show files' lists both files and directories, but
the alias `darcs show manifest' only lists files.  The \-\-files,
\-\-directories, \-\-no\-files and \-\-no\-directories modify this behaviour.

By default entries are one\-per\-line (i.e. newline separated).  This
can cause problems if the files themselves contain newlines or other
control characters.  To get aroudn this, the \-\-null option uses the
null character instead.  The script interpreting output from this
command needs to understand this idiom; `xargs \-0' is such a command.

For example, to list version\-controlled files by size:

    darcs show files \-0 | xargs \-0 ls \-ldS

.RE
.B darcs show index
.RS 4
The `darcs show index' command lists all version\-controlled files and directories along with their hashes as stored in _darcs/index. For files, the fields correspond to file size, sha256 of the current file content and the filename.
.RE
.B darcs show pristine
.RS 4
The `darcs show pristine' command lists all version\-controlled files and directories along with the hashes of their pristine copies. For files, the fields correspond to file size, sha256 of the pristine file content and the filename.
.RE
.B darcs show repo
.RS 4
The `darcs show repo' command displays statistics about the current
repository, allowing third\-party scripts to access this information
without inspecting _darcs directly (and without breaking when the
_darcs format changes).

By default, the number of patches is shown.  If this data isn't
needed, use \-\-no\-files to accelerate this command from O(n) to O(1).

By default, output is in a human\-readable format.  The \-\-xml\-output
option can be used to generate output for machine postprocessing.

.RE
.B darcs show authors
.RS 4
The `darcs show authors' command lists the authors of the current
repository, sorted by the number of patches contributed.  With the
\-\-verbose option, this command simply lists the author of each patch
(without aggregation or sorting).

An author's name or email address may change over time.  To tell Darcs
when multiple author strings refer to the same individual, create an
`.authorspellings' file in the root of the working tree.  Each line in
this file begins with an author's canonical name and address, and may
be followed by a comma separated list of extended regular expressions.
Blank lines and lines beginning with two hyphens are ignored.
The format of .authorspelling can be described by this pattern:

 name <address> [, regexp ]*

There are some pitfalls concerning special characters:
Whitespaces are stripped, if you need space in regexp use [ ]. 
Because comma serves as a separator you have to escape it if you want
it in regexp. Note that .authorspelingfile use extended regular
expressions so +, ? and so on are metacharacters and you need to 
escape them to be interpreted literally.

Any patch with an author string that matches the canonical address or
any of the associated regexps is considered to be the work of that
author.  All matching is case\-insensitive and partial (it can match a
substring). Use ^,$ to match the whole string in regexps

Currently this canonicalization step is done only in `darcs show
authors'.  Other commands, such as `darcs changes' use author strings
verbatim.

An example .authorspelling file is:

    \-\- This is a comment.
    Fred Nurk <fred@example.com>
    John Snagge <snagge@bbc.co.uk>, John, snagge@, js@(si|mit).edu
    Chuck Jones\\, Jr. <chuck@pobox.com>, cj\\+user@example.com

.RE
.B darcs show tags
.RS 4
The tags command writes a list of all tags in the repository to standard
output.

Tab characters (ASCII character 9) in tag names are changed to spaces
for better interoperability with shell tools.  A warning is printed if
this happens.
.RE
.SS "Copying patches between repositories with working copy update:"
.B darcs pull
.RI "[" "repository" "]..."
.RS 4
Pull is used to bring changes made in another repository into the current
repository (that is, either the one in the current directory, or the one
specified with the \-\-repodir option). Pull allows you to bring over all or
some of the patches that are in that repository but not in this one. Pull
accepts arguments, which are URLs from which to pull, and when called
without an argument, pull will use the repository from which you have most
recently either pushed or pulled.

.RE
.B darcs fetch
.RI "[" "repository" "]..."
.RS 4
fetch is used to bring changes made in another repository
into the current repository without actually applying
them. Fetch allows you to bring over all or
some of the patches that are in that repository but not in this one. Fetch
accepts arguments, which are URLs from which to fetch, and when called
without an argument, fetch will use the repository from which you have most
recently either pushed or pulled.
The fetched patches are stored into a patch bundle, to be later
applied using "darcs apply".
.RE
.B darcs obliterate
.RS 4
Obliterate completely removes recorded patches from your local repository.
The changes will be undone in your working copy and the patches will not be
shown in your changes list anymore.
Beware that you can lose precious code by obliterating!

.RE
.B darcs rollback
.RI "[" "file" "|" "directory" "]..."
.RS 4
Rollback is used to undo the effects of one or more patches without actually
deleting them.  Instead, it creates a new patch reversing selected portions.
of those changes. Unlike obliterate and unrecord (which accomplish a similar
goal) rollback is perfectly safe, since it leaves in the repository a record
of its changes.

.RE
.B darcs push
.RI "[" "repository" "]"
.RS 4
Push is the opposite of pull.  Push allows you to copy changes from the
current repository into another repository.

.RE
.B darcs send
.RI "[" "repository" "]"
.RS 4
Send is used to prepare a bundle of patches that can be applied to a target
repository.  Send accepts the URL of the repository as an argument.  When
called without an argument, send will use the most recent repository that
was either pushed to, pulled from or sent to.  By default, the patch bundle
is sent by email, although you may save it to a file.

.RE
.B darcs apply
.RI "<" "patchfile" ">"
.RS 4
The `darcs apply' command takes a patch bundle and attempts to insert
it into the current repository.  In addition to invoking it directly
on bundles created by `darcs send', it is used internally by `darcs
push' and `darcs put' on the remote end of an SSH connection.

If no file is supplied, the bundle is read from standard input.

If given an email instead of a patch bundle, Darcs will look for the
bundle as a MIME attachment to that email.  Currently this will fail
if the MIME boundary is rewritten, such as in Courier and Mail.app.

If the `\-\-reply noreply@example.net' option is used, and the bundle is
attached to an email, Darcs will send a report (indicating success or
failure) to the sender of the bundle (the To field).  The argument to
noreply is the address the report will appear to originate FROM.

The \-\-cc option will cause the report to be CC'd to another address,
for example `\-\-cc reports@lists.example.net,admin@lists.example.net'.
Using \-\-cc without \-\-reply is undefined.

If gpg(1) is installed, you can use `\-\-verify pubring.gpg' to reject
bundles that aren't signed by a key in pubring.gpg.

If \-\-test is supplied and a test is defined (see `darcs setpref'), the
bundle will be rejected if the test fails after applying it.  In that
case, the rejection email from \-\-reply will include the test output.

A patch bundle may introduce unresolved conflicts with existing
patches or with the working tree.  By default, Darcs will add conflict
markers (see `darcs mark\-conflicts').

The \-\-allow\-conflicts option will skip conflict marking; this is
useful when you want to treat a repository as just a bunch of patches,
such as using `darcs pull \-\-union' to download of your co\-workers
patches before going offline.

This can mess up unrecorded changes in the working tree, forcing you
to resolve the conflict immediately.  To simply reject bundles that
introduce unresolved conflicts, using the \-\-dont\-allow\-conflicts
option.  Making this the default in push\-based workflows is strongly
recommended.

Unlike most Darcs commands, `darcs apply' defaults to \-\-all.  Use the
\-\-interactive option to pick which patches to apply from a bundle.

.RE
.B darcs get
.RI "<" "repository" ">"
.RI "[<" "directory" ">]"
.RS 4
Get creates a local copy of a repository.  The optional second
argument specifies a destination directory for the new copy; if
omitted, it is inferred from the source location.

By default Darcs will copy every patch from the original repository.
This means the copy is completely independent of the original; you can
operate on the new repository even when the original is inaccessible.
If you expect the original repository to remain accessible, you can
use \-\-lazy to avoid copying patches until they are needed (`copy on
demand').  This is particularly useful when copying a remote
repository with a long history that you don't care about.

The \-\-lazy option isn't as useful for local copies, because Darcs will
automatically use `hard linking' where possible.  As well as saving
time and space, you can move or delete the original repository without
affecting a complete, hard\-linked copy.  Hard linking requires that
the copy be on the same filesystem and the original repository, and
that the filesystem support hard linking.  This includes NTFS, HFS+
and all general\-purpose Unix filesystems (such as ext3, UFS and ZFS).
FAT does not support hard links.

Darcs get will not copy unrecorded changes to the source repository's
working tree.

It is often desirable to make a copy of a repository that excludes
some patches.  For example, if releases are tagged then `darcs get
\-\-tag .' would make a copy of the repository as at the latest release.

An untagged repository state can still be identified unambiguously by
a context file, as generated by `darcs changes \-\-context'.  Given the
name of such a file, the \-\-context option will create a repository
that includes only the patches from that context.  When a user reports
a bug in an unreleased version of your project, the recommended way to
find out exactly what version they were running is to have them
include a context file in the bug report.

You can also make a copy of an untagged state using the \-\-to\-patch or
\-\-to\-match options, which exclude patches `after' the first matching
patch.  Because these options treat the set of patches as an ordered
sequence, you may get different results after reordering with `darcs
optimize', so tagging is preferred.

If the source repository is in a legacy darcs\-1 format and contains at
least one checkpoint (see `darcs optimize'), the \-\-partial option will
create a partial repository.  A partial repository discards history
from before the checkpoint in order to reduce resource requirements.
For modern darcs\-2 repositories, \-\-partial is a deprecated alias for
the \-\-lazy option.

A repository created by `darcs get' will be in the best available
format: it will be able to exchange patches with the source
repository, but will not be directly readable by Darcs binaries older
than 2.0.0.  Use the `\-\-old\-fashioned\-inventory' option if the latter
is required.

.RE
.B darcs put
.RI "<" "new" " " "repository" ">"
.RS 4
The `darcs put' command creates a copy of the current repository.  It
is currently very inefficient, so when creating local copies you
should use `darcs get . x' instead of `darcs put x'.

Currently this command just uses `darcs init' to create the target
repository, then `darcs push \-\-all' to copy patches to it.  Options
passed to `darcs put' are passed to the init and/or push commands as
appropriate.  See those commands for an explanation of each option.

.RE
.SS "Administrating repositories:"
.B darcs initialize
.RS 4
The `darcs initialize' command turns the current directory into a
Darcs repository.  Any existing files and subdirectories become
UNSAVED changes in the working tree: record them with `darcs add \-r'
and `darcs record'.

When converting a project to Darcs from some other VCS, translating
the full revision history to native Darcs patches is recommended.
(The Darcs wiki lists utilities for this.)  Because Darcs is optimized
for small patches, simply importing the latest revision as a single
large patch can PERMANENTLY degrade Darcs performance in your
repository by an order of magnitude.

This command creates the `_darcs' directory, which stores version
control metadata.  It also contains per\-repository settings in
_darcs/prefs/, which you can read about in the user manual.

In addition to the default `darcs\-2' format, there are two backward
compatibility formats for the _darcs directory.  These formats are
only useful if some of your contributors do not have access to Darcs
2.0 or higher.  In that case, you need to use the original format
(called `old\-fashioned inventory' or `darcs\-1') for any repositories
those contributors access.

As patches cannot be shared between darcs\-2 and darcs\-1 repositories,
you cannot use the darcs\-2 format for private branches of such a
project.  Instead, you should use the `hashed' format, which provides
most of the features of the darcs\-2 format, while retaining the
ability to share patches with darcs\-1 repositories.  The `darcs get'
command will do this by default.

Once all contributors have access to Darcs 2.0 or higher, a darcs\-1
project can be migrated to darcs\-2 using the `darcs convert' command.

Darcs will create a hashed repository by default when you `darcs get'
a repository in old\-fashioned inventory format.  Once all contributors
have upgraded to Darcs 2.0 or later, use `darcs convert' to convert
the project to the darcs\-2 format.

Initialize is commonly abbreviated to `init'.

.RE
.B darcs optimize
.RS 4
The `darcs optimize' command modifies the current repository in an
attempt to reduce its resource requirements.  By default a single
fast, safe optimization is performed; additional optimization
techniques can be enabled by passing options to `darcs optimize'.

The default optimization moves recent patches (those not included in
the latest tag) to the `front', reducing the amount that a typical
remote command needs to download.  It should also reduce the CPU time
needed for some operations.

The `darcs optimize \-\-relink' command hard\-links patches that the
current repository has in common with its peers.  Peers are those
repositories listed in _darcs/prefs/sources, or defined with the
`\-\-sibling' option (which can be used multiple times).

Darcs uses hard\-links automatically, so this command is rarely needed.
It is most useful if you used `cp \-r' instead of `darcs get' to copy a
repository, or if you pulled the same patch from a remote repository
into multiple local repositories.

A `darcs optimize \-\-relink\-pristine' command is also available, but
generally SHOULD NOT be used.  It results in a relatively small space
saving at the cost of making many Darcs commands MUCH slower.

By default patches are compressed with zlib (RFC 1951) to reduce
storage (and download) size.  In exceptional circumstances, it may be
preferable to avoid compression.  In this case the `\-\-dont\-compress'
option can be used (e.g. with `darcs record') to avoid compression.

The `darcs optimize \-\-uncompress' and `darcs optimize \-\-compress'
commands can be used to ensure existing patches in the current
repository are respectively uncompressed or compressed.  Note that
repositories in the legacy `old\-fashioned\-inventory' format have a .gz
extension on patch files even when uncompressed.

There is one more optimization which CAN NOT be performed by this
command.  Every time your record a patch, a new inventory file is
written to _darcs/inventories/, and old inventories are never reaped.

If _darcs/inventories/ is consuming a relatively large amount of
space, you can safely reclaim it by using `darcs get' to make a
complete copy of the repo.  When doing so, don't forget to copy over
any unsaved changes you have made to the working tree or to
unversioned files in _darcs/prefs/ (such as _darcs/prefs/author).

.RE
.B darcs check
.RS 4
This command verifies that the patches in the repository, when applied
successively to an empty tree, result in the pristine tree.  If not,
the differences are printed and Darcs exits unsucessfully (with a
non\-zero exit status).

If the repository is in darcs\-1 format and has a checkpoint, you can
use the \-\-partial option to start checking from the latest checkpoint.
This is the default for partial darcs\-1 repositories; the \-\-complete
option to forces a full check.

If a regression test is defined (see `darcs setpref') it will be run
by `darcs check'.  Use the \-\-no\-test option to disable this.

.RE
.B darcs repair
.RS 4
The `darcs repair' command attempts to fix corruption in the current
repository.  Currently it can only repair damage to the pristine tree,
which is where most corruption occurs.

.RE
.B darcs convert
.RI "<" "source" ">"
.RI "[<" "destination" ">]"
.RS 4
The current repository format is called `darcs\-2'.  It was introduced
in Darcs 2.0 and became the default for new projects in Darcs 2.2.
The `darcs convert' command allows existing projects to migrate to
this format from the older `darcs\-1' format.

This command DOES NOT modify the source repository; a new destination
repository is created.  It is safe to run this command more than once
on a repository (e.g. for testing), before the final conversion.

WARNING: the repository produced by this command is not understood by
Darcs 1.x, and patches cannot be exchanged between repositories in
darcs\-1 and darcs\-2 formats.

Furthermore, darcs 2 repositories created by different invocations of
this command SHOULD NOT exchange patches, unless those repositories
had no patches in common when they were converted.  (That is, within a
set of repos that exchange patches, no patch should be converted more
than once.)

Due to this limitation, migrating a multi\-branch project is a little
awkward.  Sorry!  Here is the recommended process:

 1. for each branch `foo', tag that branch with `foo\-final';
 2. merge all branches together (\-\-allow\-conflicts may help);
 3. run `darcs optimize \-\-reorder' on the result;
 4. run `darcs convert' to create a merged darcs\-2 repository;
 5. re\-create each branch by calling `darcs get \-\-tag foo\-final' on
    the darcs\-2 repository; and finally
 6. use `darcs obliterate' to delete the foo\-final tags.

.RE

.SH ENVIRONMENT
.SS "HOME and APPDATA"
Per\-user preferences are set in $HOME/.darcs (on Unix) or
%APPDATA%/darcs (on Windows).  This is also the default location of
the cache.
.SS "DARCS_EDITOR, DARCSEDITOR, VISUAL and EDITOR"
To edit a patch description of email comment, Darcs will invoke an
external editor.  Your preferred editor can be set as any of the
environment variables $DARCS_EDITOR, $DARCSEDITOR, $VISUAL or $EDITOR.
If none of these are set, vi(1) is used.  If vi crashes or is not
found in your PATH, emacs, emacs \-nw, nano and (on Windows) edit are
each tried in turn.
.SS "DARCS_PAGER and PAGER"
Darcs will sometimes invoke a pager if it deems output to be too long
to fit onscreen.  Darcs will use the pager specified by $DARCS_PAGER
or $PAGER.  If neither are set, `less' will be used.
.SS "DARCS_TMPDIR and TMPDIR"
Darcs often creates temporary directories.  For example, the `darcs
diff' command creates two for the working trees to be diffed.  By
default temporary directories are created in /tmp, or if that doesn't
exist, in _darcs (within the current repo).  This can be overridden by
specifying some other directory in the file _darcs/prefs/tmpdir or the
environment variable $DARCS_TMPDIR or $TMPDIR.
.SS "DARCS_KEEP_TMPDIR"
If the environment variable DARCS_KEEP_TMPDIR is defined, darcs will
not remove the temporary directories it creates.  This is intended
primarily for debugging Darcs itself, but it can also be useful, for
example, to determine why your test preference (see `darcs setpref')
is failing when you run `darcs record', but working when run manually.
.SS "DARCS_EMAIL and EMAIL"
Each patch is attributed to its author, usually by email address (for
example, `Fred Bloggs <fred@example.net>').  Darcs looks in several
places for this author string: the \-\-author option, the files
_darcs/prefs/author (in the repository) and ~/.darcs/author (in your
home directory), and the environment variables $DARCS_EMAIL and
$EMAIL.  If none of those exist, Darcs will prompt you for an author
string and write it to _darcs/prefs/author.
.SS "SENDMAIL"
On Unix, the `darcs send' command relies on sendmail(8).  The
`\-\-sendmail\-command' or $SENDMAIL environment variable can be used to
provide an explicit path to this program; otherwise the standard
locations /usr/sbin/sendmail and /usr/lib/sendmail will be tried.
.SS "DARCS_SSH"
Repositories of the form [user@]host:[dir] are taken to be remote
repositories, which Darcs accesses with the external program ssh(1).

The environment variable $DARCS_SSH can be used to specify an
alternative SSH client.  Arguments may be included, separated by
whitespace.  The value is not interpreted by a shell, so shell
constructs cannot be used; in particular, it is not possible for the
program name to contain whitespace by using quoting or escaping.
.SS "DARCS_SCP and DARCS_SFTP"
When reading from a remote repository, Darcs will attempt to run
`darcs transfer\-mode' on the remote host.  This will fail if the
remote host only has Darcs 1 installed, doesn't have Darcs installed
at all, or only allows SFTP.

If transfer\-mode fails, Darcs will fall back on scp(1) and sftp(1).
The commands invoked can be customized with the environment variables
$DARCS_SCP and $DARCS_SFTP respectively, which behave like $DARCS_SSH.
If the remote end allows only sftp, try setting DARCS_SCP=sftp.
.SS "SSH_PORT"
If this environment variable is set, it will be used as the port
number for all SSH calls made by Darcs (when accessing remote
repositories over SSH).  This is useful if your SSH server does not
run on the default port, and your SSH client does not support
ssh_config(5).  OpenSSH users will probably prefer to put something
like `Host *.example.net Port 443' into their ~/.ssh/config file.
.SS "HTTP_PROXY, HTTPS_PROXY, FTP_PROXY, ALL_PROXY and NO_PROXY"
If Darcs was built with libcurl, the environment variables HTTP_PROXY,
HTTPS_PROXY and FTP_PROXY can be set to the URL of a proxy in the form

  [protocol://]<host>[:port]

In which case libcurl will use the proxy for the associated protocol
(HTTP, HTTPS and FTP).  The environment variable ALL_PROXY can be used
to set a single proxy for all libcurl requests.

If the environment variable NO_PROXY is a comma\-separated list of host
names, access to those hosts will bypass proxies defined by the above
variables.  For example, it is quite common to avoid proxying requests
to machines on the local network with

  NO_PROXY=localhost,*.localdomain

For compatibility with lynx et al, lowercase equivalents of these
environment variables (e.g. $http_proxy) are also understood and are
used in preference to the uppercase versions.

If Darcs was not built with libcurl, all these environment variables
are silently ignored, and there is no way to use a web proxy.
.SS "DARCS_PROXYUSERPWD"
If Darcs was built with libcurl, and you are using a web proxy that
requires authentication, you can set the $DARCS_PROXYUSERPWD
environment variable to the username and password expected by the
proxy, separated by a colon.  This environment variable is silently
ignored if Darcs was not built with libcurl.

.SH FILES
.SS "_darcs/prefs/binaries"
This file contains a list of extended regular expressions, one per
line.  A file path matching any of these expressions is assumed to
contain binary data (not text).  The entries in ~/.darcs/binaries (if
it exists) supplement those in this file.

Blank lines, and lines beginning with an octothorpe (#) are ignored.
See regex(7) for a description of extended regular expressions.

.SH BUGS
At http://bugs.darcs.net/ you can find a list of known
bugs in Darcs.  Unknown bugs can be reported at that
site (after creating an account) or by emailing the
report to bugs@darcs.net.
.SH SEE ALSO
A user manual is included with Darcs, in PDF and HTML
form.  It can also be found at http://darcs.net/manual/.
