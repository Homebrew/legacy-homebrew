require 'formula'

class Libspatialite < Formula
  homepage 'https://www.gaia-gis.it/fossil/libspatialite/index'
  url 'http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-4.1.1.tar.gz'
  sha1 'b8ed50fb66c4a898867cdf9d724d524c5e27e8aa'

  bottle do
    cellar :any
    sha1 "07ce6d5b8eed256daca45f7159d90b4a4907b986" => :mavericks
    sha1 "cfb030a596a069d726be7c98d4be98005fc6a727" => :mountain_lion
    sha1 "1c7f5843303e20d7314fc827b66c8d62bcbab5aa" => :lion
  end

  head do
    url "fossil://https://www.gaia-gis.it/fossil/libspatialite"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option 'without-freexl', 'Build without support for reading Excel files'
  option 'without-libxml2', 'Disable support for xml parsing (parsing needed by spatialite-gui)'
  option 'without-liblwgeom', 'Build without additional sanitization/segmentation routines provided by PostGIS 2.0+ library'
  option "with-geopackage", "Build with experimental OGC GeoPackage support"

  depends_on 'pkg-config' => :build
  depends_on 'proj'
  depends_on 'geos'
  # Needs SQLite > 3.7.3 which rules out system SQLite on Snow Leopard and
  # below. Also needs dynamic extension support which rules out system SQLite
  # on Lion. Finally, RTree index support is required as well.
  depends_on 'sqlite'
  depends_on 'libxml2' => :recommended
  depends_on 'freexl' => :recommended
  depends_on 'liblwgeom' => :recommended

  def install
    if build.head?
      system "autoreconf", "-fi"
      # new SQLite3 extension won't load via just 'spatialite' unless named spatialite.dylib
      inreplace "configure",
                "shrext_cmds='`test .$module = .yes && echo .so || echo .dylib`'",
                "shrext_cmds='.dylib'"
    end

    # Ensure Homebrew's libsqlite is found before the system version.
    sqlite = Formula["sqlite"]
    ENV.append 'LDFLAGS', "-L#{sqlite.opt_lib}"
    ENV.append 'CFLAGS', "-I#{sqlite.opt_include}"

    if build.with? 'liblwgeom'
      lwgeom = Formula["liblwgeom"]
      ENV.append 'LDFLAGS', "-L#{lwgeom.opt_lib}"
      ENV.append 'CFLAGS', "-I#{lwgeom.opt_include}"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-sysroot=#{HOMEBREW_PREFIX}
    ]
    args << '--enable-freexl=no' if build.without? 'freexl'
    args << '--enable-libxml2=yes' if build.with? 'libxml2'
    args << '--enable-lwgeom=yes' if build.with? 'liblwgeom'
    args << "--enable-geopackage=yes" if build.with? "geopackage"

    system './configure', *args
    system "make", "install"
  end

end
