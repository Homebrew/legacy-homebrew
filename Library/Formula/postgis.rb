class Postgis < Formula
  desc "Adds support for geographic objects to PostgreSQL"
  homepage "http://postgis.net"
  url "http://download.osgeo.org/postgis/source/postgis-2.1.7.tar.gz"
  sha256 "00ab79a3f609d7ea458f6fc358032ad059cb720baf88285243d6436a597a7ec2"
  revision 1

  def pour_bottle?
    # Postgres extensions must live in the Postgres prefix, which precludes
    # bottling: https://github.com/Homebrew/homebrew/issues/10247
    # Overcoming this will likely require changes in Postgres itself.
    false
  end

  head do
    url "http://svn.osgeo.org/postgis/trunk/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-gui", "Build shp2pgsql-gui in addition to command line tools"
  option "without-gdal", "Disable postgis raster support"
  option "with-html-docs", "Generate multi-file HTML documentation"
  option "with-api-docs", "Generate developer API documentation (long process)"

  depends_on "pkg-config" => :build
  depends_on "gpp" => :build
  depends_on "postgresql"
  depends_on "proj"
  depends_on "geos"

  depends_on "gtk+" if build.with? "gui"

  # For GeoJSON and raster handling
  depends_on "json-c"
  depends_on "gdal" => :recommended

  # For advanced 2D/3D functions
  depends_on "sfcgal" => :recommended

  if build.with? "html-docs"
    depends_on "imagemagick"
    depends_on "docbook-xsl"
  end

  if build.with? "api-docs"
    depends_on "graphviz"
    depends_on "doxygen"
  end

  def install
    # Follow the PostgreSQL linked keg back to the active Postgres installation
    # as it is common for people to avoid upgrading Postgres.
    postgres_realpath = Formula["postgresql"].opt_prefix.realpath

    ENV.deparallelize

    args = [
      # Can't use --prefix, PostGIS disrespects it and flat-out refuses to
      # accept it with 2.0.
      "--with-projdir=#{HOMEBREW_PREFIX}",
      "--with-jsondir=#{Formula["json-c"].opt_prefix}",
      # This is against Homebrew guidelines, but we have to do it as the
      # PostGIS plugin libraries can only be properly inserted into Homebrew's
      # Postgresql keg.
      "--with-pgconfig=#{postgres_realpath}/bin/pg_config",
      # Unfortunately, NLS support causes all kinds of headaches because
      # PostGIS gets all of its compiler flags from the PGXS makefiles. This
      # makes it nigh impossible to tell the buildsystem where our keg-only
      # gettext installations are.
      "--disable-nls"
    ]

    args << "--with-gui" if build.with? "gui"
    args << "--without-raster" if build.without? "gdal"

    args << "--with-xsldir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl" if build.with? "html-docs"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"

    if build.with? "html-docs"
      cd "doc" do
        ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
        system "make", "chunked-html"
        doc.install "html"
      end
    end

    if build.with? "api-docs"
      cd "doc" do
        system "make", "doxygen"
        doc.install "doxygen/html" => "api"
      end
    end

    # PostGIS includes the PGXS makefiles and so will install __everything__
    # into the Postgres keg instead of the PostGIS keg. Unfortunately, some
    # things have to be inside the Postgres keg in order to be function. So, we
    # install everything to a staging directory and manually move the pieces
    # into the appropriate prefixes.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    # Install PostGIS plugin libraries into the Postgres keg so that they can
    # be loaded and so PostGIS databases will continue to function even if
    # PostGIS is removed.
    (postgres_realpath/"lib").install Dir["stage/**/*.so"]

    # Install extension scripts to the Postgres keg.
    # `CREATE EXTENSION postgis;` won't work if these are located elsewhere.
    (postgres_realpath/"share/postgresql/extension").install Dir["stage/**/extension/*"]

    bin.install Dir["stage/**/bin/*"]
    lib.install Dir["stage/**/lib/*"]
    include.install Dir["stage/**/include/*"]

    # Stand-alone SQL files will be installed the share folder
    (share/"postgis").install Dir["stage/**/contrib/postgis-2.1/*"]

    # Extension scripts
    bin.install %w[
      utils/create_undef.pl
      utils/postgis_proc_upgrade.pl
      utils/postgis_restore.pl
      utils/profile_intersects.pl
      utils/test_estimation.pl
      utils/test_geography_estimation.pl
      utils/test_geography_joinestimation.pl
      utils/test_joinestimation.pl
    ]

    man1.install Dir["doc/**/*.1"]
  end

  def caveats
    pg = Formula["postgresql"].opt_prefix
    <<-EOS.undent
      To create a spatially-enabled database, see the documentation:
        http://postgis.net/docs/manual-2.1/postgis_installation.html#create_new_db_extensions
      If you are currently using PostGIS 2.0+, you can go the soft upgrade path:
        ALTER EXTENSION postgis UPDATE TO "2.1.5";
      Users of 1.5 and below will need to go the hard-upgrade path, see here:
        http://postgis.net/docs/manual-2.1/postgis_installation.html#upgrading

      PostGIS SQL scripts installed to:
        #{HOMEBREW_PREFIX}/share/postgis
      PostGIS plugin libraries installed to:
        #{pg}/lib
      PostGIS extension modules installed to:
        #{pg}/share/postgresql/extension
      EOS
  end

  test do
    require "base64"
    (testpath/"brew.shp").write(::Base64.decode64("AAAnCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoOgDAAALAAAAAAAAAAAAAAAA\nAAAAAADwPwAAAAAAABBAAAAAAAAAFEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAEAAAASCwAAAAAAAAAAAPA/AAAAAAAA8D8AAAAAAAAA\nAAAAAAAAAAAAAAAAAgAAABILAAAAAAAAAAAACEAAAAAAAADwPwAAAAAAAAAA\nAAAAAAAAAAAAAAADAAAAEgsAAAAAAAAAAAAQQAAAAAAAAAhAAAAAAAAAAAAA\nAAAAAAAAAAAAAAQAAAASCwAAAAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAAAAA\nAAAAAAAAAAAABQAAABILAAAAAAAAAAAAAAAAAAAAAAAUQAAAAAAAACJAAAAA\nAAAAAEA=\n"))
    (testpath/"brew.dbf").write(::Base64.decode64("A3IJGgUAAABhAFsAAAAAAAAAAAAAAAAAAAAAAAAAAABGSVJTVF9GTEQAAEMA\nAAAAMgAAAAAAAAAAAAAAAAAAAFNFQ09ORF9GTEQAQwAAAAAoAAAAAAAAAAAA\nAAAAAAAADSBGaXJzdCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgICAgIFBvaW50ICAgICAgICAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgU2Vjb25kICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgICAgICBQb2ludCAgICAgICAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgIFRoaXJkICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgICAgICAgUG9pbnQgICAgICAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgICBGb3VydGggICAgICAgICAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgICAgICAgIFBvaW50ICAgICAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgICAgQXBwZW5kZWQgICAgICAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgICAgICAgICBQb2ludCAgICAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgICAg\n"))
    (testpath/"brew.shx").write(::Base64.decode64("AAAnCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARugDAAALAAAAAAAAAAAAAAAA\nAAAAAADwPwAAAAAAABBAAAAAAAAAFEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAADIAAAASAAAASAAAABIAAABeAAAAEgAAAHQAAAASAAAA\nigAAABI=\n"))
    result = shell_output("#{bin}/shp2pgsql #{testpath}/brew.shp")
    assert_match /Point/, result
    assert_match /AddGeometryColumn/, result
  end
end
