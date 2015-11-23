# Querying Brew
_In this document we will be using [jq](https://stedolan.github.io/jq/) to parse JSON, available from Homebrew using `brew install jq`._

## Overview

`brew` provides commands for getting common types of information out of the system. `brew list` showed installed formulae. `brew deps foo` shows the dependencies that `foo` needs.

Additional commands, including external commands, can of course be written to provide more detailed information. There are a couple of disadvantages here. First, it means writing Ruby against a possibly changing Homebrew codebase. There will be more code to touch during refactors, and Homebrew can't guarantee that external commands will continue to work. Second, it means designing the commands themselves, specifying input parameters and output formats.

To enable users to do rich queries without the problems above, Homebrew provides the `brew info` command.

## `brew info --json`

`brew info` outputs JSON-formatted information about formulae. This JSON can then be parsed using your tools of choice.

From the manpage:

  * `info --json=<version>` (--all|--installed|<formula>):
    Print a JSON representation of <formula>. Currently the only accepted value
    for <version> is `v1`.

    Pass `--all` to get information on all formulae, or `--installed` to get
    information on all installed formulae.

The current schema version is `v1`. Note that fields may be added to the schema as needed without incrementing the schema. Any significant breaking changes will cause a change to the schema version.

The schema itself is not currently documented outside of the code that generates it: [Formula#to_hash](https://github.com/Homebrew/homebrew/blob/master/Library/Homebrew/formula.rb#L443)

(**TODO**: add a manpage for the schema)

## Examples

_The top-level element of the JSON is always an array, so the `map` operator is used to act on the data._

### Prety-print a single formula's info

`brew info --json=v1 tig | jq .`

### Installed formulae

To show full JSON information about all installed formulae:

`brew info --json=v1 --all | jq "map(select(.installed != []))"`

You'll note that processing all formulae can be slow; it's quicker to let `brew` do this:

`brew info --json=v1 --installed`

### Linked keg-only formulae

Some formulae are marked as "keg-only", meaning that installed files are not linked to the shared `bin`, `lib`, etc. directors, as doing so can cause conflicts. Such formulae can be forced to link to the shared directories, but doing so is not recommended (and will cause `brew doctor` to complain.)

To find the names of linked keg-only formulae:

`brew info --json=v1 --installed | jq "map(select(.keg_only == true and .linked_keg != null) | .name)"`

### Unlinked normal formulae

To find the names of normal (not keg-only) formulae that are installed, but not linked to the shared directories:

`brew info --json=v1 --installed | jq "map(select(.keg_only == false and .linked_keg == null) | .name)"`

## Concluding remarks

Using the JSON output, queries can be made against Homebrew with less risk of being broken due to Homebrew code changes, and without needing to understand Homebrew's ruby internals.

If the JSON does not provide some information that it ought to, please submit request, preferably with a patch to add the desired information.
