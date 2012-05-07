require 'formula'

def without_freexl?
  ARGV.include? '--without-freexl'
end

class Libspatialite < Formula
  homepage 'https://www.gaia-gis.it/fossil/libspatialite/index'
  url 'http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-3.0.1.tar.gz'
  md5 '450d1a0d9da1bd9f770b7db3f2509f69'

  def options
    [['--without-freexl', 'Build without support for reading Excel files']]
  end

  depends_on 'proj'
  depends_on 'geos'
  # Needs SQLite > 3.7.3 which rules out system SQLite on Snow Leopard and
  # below. Also needs dynamic extension support which rules out system SQLite
  # on Lion. Finally, RTree index support is required as well.
  depends_on 'sqlite'

  depends_on 'freexl' unless without_freexl?

  def install
    # O2 and O3 leads to corrupt/invalid rtree indexes
    # http://groups.google.com/group/spatialite-users/browse_thread/thread/8e1cfa79f2d02a00#
    ENV.Os
    # Ensure Homebrew's libsqlite is found before the system version.
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-sysroot=#{HOMEBREW_PREFIX}
    ]
    args << '--enable-freexl=no' if without_freexl?

    system './configure', *args
    system "make install"
  end
end
