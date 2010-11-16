require 'formula'

class Ghc <Formula
  homepage 'http://haskell.org/ghc/'
  url "http://new-www.haskell.org/ghc/dist/7.0.1/GHC-7.0.1-i386.pkg"
  version '7.0.1'
  md5 '0ec6e4aee49a156714cd37d5d5636b24'

  # Avoid stripping the Haskell binaries & libraries.
  # See: http://hackage.haskell.org/trac/ghc/ticket/2458
  skip_clean ['bin', 'lib']

  def replace_all foo, bar
    # Find all text files containing foo and replace it with bar
    files = `/usr/bin/grep -lsIR #{foo} .`.split
    inreplace files, foo, bar
  end

  def short_version
    "#{version}-i386"
  end

  def install
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
