require 'formula'

class PkgCurlDownloadStrategy <CurlDownloadStrategy
  def stage
    safe_system '/usr/sbin/pkgutil', '--expand', @tarball_path, File.basename(@url)
    chdir
  end
end

# Remember to update the formula for Cabal when updating this formula
class Ghc <Formula
  homepage 'http://haskell.org/ghc/'
  version '6.12.1'
  url "http://haskell.org/ghc/dist/6.12.1/GHC-#{version}-i386.pkg"
  md5 '7f50698a6f34b978027a43fd836443e7'

  skip_clean :bin #http://hackage.haskell.org/trac/ghc/ticket/2458

  def download_strategy
    # Extract files from .pkg while caching the .pkg
    PkgCurlDownloadStrategy
  end

  def replace_all foo, bar
    # Find all text files containing foo and replace it with bar
    files = `/usr/bin/grep -lsIR #{foo} .`.split
    inreplace files, foo, bar
  end

  def install
    # Extract files from .pax.gz
    system '/bin/pax -f ghc.pkg/Payload -p p -rz'
    cd 'GHC.framework/Versions/612/usr'

    # Fix paths
    replace_all '/Library/Frameworks/GHC.framework/Versions/612/usr/lib/ghc-6.12.1', "#{lib}/ghc"
    replace_all '/Library/Frameworks/GHC.framework/Versions/612/usr', prefix
    mv 'lib/ghc-6.12.1', 'lib/ghc'

    prefix.install ['bin', 'lib', 'share']

    # Regenerate GHC package cache
    rm "#{lib}/ghc/package.conf.d/package.cache"
    system "#{bin}/ghc-pkg", 'recache', '--package-conf', "#{lib}/ghc/package.conf.d"
  end
end
