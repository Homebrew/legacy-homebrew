require 'formula'

def without_freexl?
  ARGV.include? '--without-freexl'
end

class Libspatialite < Formula
  homepage 'https://www.gaia-gis.it/fossil/libspatialite/index'
  url 'http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-amalgamation-3.0.1.tar.gz'
  md5 'df7f0f714c2de1dc2791ddef6e8eaba5'

  def options
    [['--without-freexl', 'Build without support for reading Excel files']]
  end

  depends_on 'proj'
  depends_on 'geos'

  depends_on 'freexl' unless without_freexl?

  def install
    # O2 and O3 leads to corrupt/invalid rtree indexes
    # http://groups.google.com/group/spatialite-users/browse_thread/thread/8e1cfa79f2d02a00#
    ENV.Os
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --target=macosx
    ]
    args << '--enable-freexl=no' if without_freexl?

    system './configure', *args
    system "make install"
  end
end
