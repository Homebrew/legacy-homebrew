require 'formula'

class Ghc <Formula
  homepage 'http://haskell.org/ghc/'
  version '6.12.3'
  url "http://darcs.haskell.org/download/dist/#{version}/GHC-#{version}-i386.pkg"
  md5 '58399e3af68f50a23a847bdfe3de5aca'

  # Avoid stripping the Haskell binaries & libraries.
  # See: http://hackage.haskell.org/trac/ghc/ticket/2458
  skip_clean ['bin', 'lib']

  def replace_all foo, bar
    # Find all text files containing foo and replace it with bar
    files = `/usr/bin/grep -lsIR #{foo} .`.split
    inreplace files, foo, bar
  end

  def install
    short_version = version.split('.').first(2).join('')

    # Extract files from .pax.gz
    system '/bin/pax -f ghc.pkg/Payload -p p -rz'
    cd "GHC.framework/Versions/#{short_version}/usr"

    # Fix paths
    replace_all "/Library/Frameworks/GHC.framework/Versions/#{short_version}/usr/lib/ghc-#{version}", "#{lib}/ghc"
    replace_all "/Library/Frameworks/GHC.framework/Versions/#{short_version}/usr", prefix

    prefix.install ['bin', 'share']

    # Remove version from lib folder
    lib.install "lib/ghc-#{version}" => 'ghc'

    # Fix ghc-asm Perl reference
    inreplace "#{lib}/ghc/ghc-asm", "#!/opt/local/bin/perl", "#!/usr/bin/env perl"

    # Regenerate GHC package cache
    rm "#{lib}/ghc/package.conf.d/package.cache"
    system "#{bin}/ghc-pkg", 'recache', '--package-conf', "#{lib}/ghc/package.conf.d"
  end
end
