# Bottles
Bottles are Homebrew's binary packages. They are produced by installing a formula with `brew install --build-bottle $FORMULA` and then bottling it with `brew bottle $FORMULA`. This outputs the bottle DSL which should be inserted into the formula file.

## Bottle Usage
If a bottle is available and usable it will be downloaded and poured automatically when you `brew install <formula>`. If you wish to disable this you can do it by specifying `--build-from-source`.

Bottles will not be used if the user requests it (see above), if the formula requests it (with `pour_bottle?`), if any options are specified on installation (bottles are all compiled with default options), if the bottle is not up to date (e.g. lacking a checksum) or the bottle's `cellar` is not `:any` or equal to the current `HOMEBREW_CELLAR`.

### Local Bottle Usage
Bottles can also be cached locally and installed by path e.g. `brew install /Library/Caches/Homebrew/qt-4.8.4.mountain_lion.bottle.1.tar.gz`.

## Bottle Creation
Bottles are currently created using the [Brew Test Bot](Brew-Test-Bot.md). We will be slowly adding them to all formulae.

By default, bottles will be built for the oldest CPU supported by the OS/architecture you're building for. (That's Core 2 for 64-bit OSs, Core for 32-bit.) This ensures that bottles are compatible with all computers you might distribute them to. If you *really* want your bottles to be optimized for something else, you can pass the `--bottle-arch=` option to build for another architecture - for example, `brew install foo --bottle-arch=penyrn`. Just remember that if you build for a newer architecture some of your users might get binaries they can't run and that would be sad!

## Bottle Format
Bottles are simple gzipped tarballs of compiled binaries. Any metadata is stored in a formula's bottle DSL and in the bottle filename (i.e. MacOS version, revision).

## Bottle DSL (Domain Specific Language)
Bottles have a DSL to be used in formulae which is contained in the `bottle do ... end` block.

A simple (and typical) example:
```ruby
bottle do
  sha256 "4921af80137af9cc3d38fd17c9120da882448a090b0a8a3a19af3199b415bfca" => :yosemite
  sha256 "c71db15326ee9196cd98602e38d0b7fb2b818cdd48eede4ee8eb827d809e09ba" => :mavericks
  sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7" => :mountain_lion
end
```

A full example:
```ruby
bottle do
  root_url "https://example.com"
  prefix "/opt/homebrew"
  cellar "/opt/homebrew/Cellar"
  revision 4
  sha256 "4921af80137af9cc3d38fd17c9120da882448a090b0a8a3a19af3199b415bfca" => :yosemite
  sha256 "c71db15326ee9196cd98602e38d0b7fb2b818cdd48eede4ee8eb827d809e09ba" => :mavericks
  sha256 "85cc828a96735bdafcf29eb6291ca91bac846579bcef7308536e0c875d6c81d7" => :mountain_lion
end
```

### `root_url`
Optionally contains the URL root used to calculate bottle URLs.
By default this is omitted and the Homebrew default bottle URL root is used. This may be useful for taps which wish to provide bottles for their formulae or to cater for a non-default `HOMEBREW_CELLAR`.

### `cellar`
Optionally contains the value of `HOMEBREW_CELLAR` in which the bottles were built.
Most compiled software contains references to its compiled location so cannot be simply relocated anywhere on disk. If this value is `:any` this means that the bottle can be safely installed in any Cellar as it did not contain any references to its installation Cellar. This can be omitted if a bottle is compiled (as all default Homebrew ones are) for the default `HOMEBREW_CELLAR` of `/usr/local/Cellar`

### `prefix`
Optionally contains the value of `HOMEBREW_PREFIX` in which the bottles were built.
See description of `cellar`. When `cellar` is `:any` prefix should be omitted.

### `revision`
Optionally contains the revision of the bottle.
Sometimes bottles may need be updated without bumping the version of the formula e.g. a new patch was applied. In that case the revision will have a value of 1 or more.

### `sha256`
Contains the SHA-256 of bottle for a particular version of OS X.

## Formula DSL
Additionally there is a method available in the formula DSL.

### `pour_bottle?`
Optionally returns a boolean to decide whether a bottle should be used for this formula.
For example a bottle may break if another formula has been compiled with non-default options so this method could check for that case and return `false`.

## Planned Improvements
Most bottle features have been (and planned improvements will be) implemented by @mikemcquaid. Contact him directly with questions.
