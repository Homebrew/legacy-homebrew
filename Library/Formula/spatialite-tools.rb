require 'formula'

class SpatialiteTools <Formula
  url 'http://www.gaia-gis.it/spatialite-2.4.0-4/spatialite-tools-2.4.0.tar.gz'
  version '2.4.0-rc4'
  homepage 'http://www.gaia-gis.it/spatialite/'
  md5 'e161e774a26e874d7d92d428ae2ad685'

  depends_on 'pkg-config' => :build
  depends_on 'libspatialite'

  def install
    ENV.append 'LDFLAGS', '-liconv' # Fixes 3328 should be removed with next version
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--target=macosx"
    system "make install"
  end
end
