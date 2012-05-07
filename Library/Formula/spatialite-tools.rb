require 'formula'

class SpatialiteTools < Formula
  homepage 'https://www.gaia-gis.it/fossil/spatialite-tools/index'
  url 'http://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-3.1.0a.tar.gz'
  md5 '241f0eb00da1b19c1088d53684c24214'

  depends_on 'pkg-config' => :build

  depends_on 'libspatialite'
  depends_on 'readosm'

  def install
    # See: https://github.com/mxcl/homebrew/issues/3328
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"
    ENV.append 'LDFLAGS', '-liconv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
