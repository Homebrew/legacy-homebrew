require 'formula'

class SpatialiteTools < Formula
  homepage 'https://www.gaia-gis.it/fossil/spatialite-tools/index'
  url 'http://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-3.0.0-stable.tar.gz'
  md5 'b54f94eb5297c1cff1820c2a35752a9c'

  depends_on 'pkg-config' => :build
  depends_on 'libspatialite'

  def install
    # See: https://github.com/mxcl/homebrew/issues/3328
    ENV.append 'LDFLAGS', '-liconv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--target=macosx"
    system "make install"
  end
end
