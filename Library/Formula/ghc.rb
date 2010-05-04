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
  version '6.12.2'
  url "http://haskell.org/ghc/dist/#{version}/GHC-#{version}-i386.pkg"
  md5 '52c79e7a1a29f0e385e23b3023ef6bbc'

  # Avoid stripping the Haskell binaries AND libraries; http://hackage.haskell.org/trac/ghc/ticket/2458
  skip_clean ['bin', 'lib']

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
    short_version = version.split('.').first(2).join('')

    # Extract files from .pax.gz
    system '/bin/pax -f ghc.pkg/Payload -p p -rz'
    cd "GHC.framework/Versions/#{short_version}/usr"

    # Fix paths
    replace_all "/Library/Frameworks/GHC.framework/Versions/#{short_version}/usr/lib/ghc-#{version}", "#{lib}/ghc"
    replace_all "/Library/Frameworks/GHC.framework/Versions/#{short_version}/usr", prefix
    mv "lib/ghc-#{version}", 'lib/ghc'

    prefix.install ['bin', 'lib', 'share']

    # Regenerate GHC package cache
    rm "#{lib}/ghc/package.conf.d/package.cache"
    system "#{bin}/ghc-pkg", 'recache', '--package-conf', "#{lib}/ghc/package.conf.d"
  end
end
