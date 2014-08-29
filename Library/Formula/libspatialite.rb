require 'formula'

class Libspatialite < Formula
  homepage 'https://www.gaia-gis.it/fossil/libspatialite/index'
  url "http://www.gaia-gis.it/gaia-sins/libspatialite-4.2.0.tar.gz"
  sha1 "698bf70bec669ddcbf1b0cc48f40c2e03776bffc"

  bottle do
    cellar :any
    sha1 "2590b61596c773689886f44d589c4ec7436a35e6" => :mavericks
    sha1 "4fbc52ea4718dd46d68051f5bed24764040ed2d8" => :mountain_lion
    sha1 "29b0babb1e163018ba0bdbf22b16587efe4dcad5" => :lion
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
  option "without-geopackage", "Build without OGC GeoPackage support"
  option "without-check", "Do not run `make check` prior to installing"

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
    system "autoreconf", "-fi" if build.head?

    # New SQLite3 extension won't load via SELECT load_extension('mod_spatialite');
    # unless named mod_spatialite.dylib (should actually be mod_spatialite.bundle)
    # See: https://groups.google.com/forum/#!topic/spatialite-users/EqJAB8FYRdI
    #      needs upstream fixes in both SQLite and libtool
    inreplace "configure",
              "shrext_cmds='`test .$module = .yes && echo .so || echo .dylib`'",
              "shrext_cmds='.dylib'"

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
    args << "--enable-geocallbacks"
    args << '--enable-freexl=no' if build.without? 'freexl'
    args << "--enable-libxml2=no" if build.without? "libxml2"
    args << '--enable-lwgeom=yes' if build.with? 'liblwgeom'
    args << "--enable-geopackage=no" if build.without? "geopackage"

    system './configure', *args
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    # Verify mod_spatialite extension can be loaded using Homebrew's SQLite
    system "echo \"SELECT load_extension('#{opt_lib}/mod_spatialite');\" | #{Formula["sqlite"].opt_bin}/sqlite3"
  end

end
