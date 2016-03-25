class Postgis < Formula
  desc "Adds support for geographic objects to PostgreSQL"
  homepage "http://postgis.net"
  url "http://download.osgeo.org/postgis/source/postgis-2.2.1.tar.gz"
  sha256 "0fe500b0250203aac656bfa8f42f8458b63f33258404844e066e0e535988fa09"

  bottle do
    cellar :any
    revision 2
    sha256 "2dd01d3e7b0a5a8c7b69bdbd8389ab8d857de755e393e213dc818828fb0dd540" => :el_capitan
    sha256 "6aed14810aea9784c4dc2a00ec825bb6032f200e7512c9611a41a82fba1e6d55" => :yosemite
    sha256 "2d4df95d9aa6609d8bf7409be18a4173b7ba7d364a3df1e0a8445d330ae8fbb2" => :mavericks
  end

  head do
    url "https://svn.osgeo.org/postgis/trunk/"

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
  depends_on "pcre" => :build if build.with? "gdal"

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
    ENV.deparallelize

    args = [
      "--with-projdir=#{Formula["proj"].opt_prefix}",
      "--with-jsondir=#{Formula["json-c"].opt_prefix}",
      "--with-pgconfig=#{Formula["postgresql"].opt_bin}/pg_config",
      # Unfortunately, NLS support causes all kinds of headaches because
      # PostGIS gets all of its compiler flags from the PGXS makefiles. This
      # makes it nigh impossible to tell the buildsystem where our keg-only
      # gettext installations are.
      "--disable-nls",
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

    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    bin.install Dir["stage/**/bin/*"]
    lib.install Dir["stage/**/lib/*"]
    include.install Dir["stage/**/include/*"]
    (doc/"postgresql/extension").install Dir["stage/**/share/doc/postgresql/extension/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
    pkgshare.install Dir["stage/**/contrib/postgis-*/*"]
    (share/"postgis_topology").install Dir["stage/**/contrib/postgis_topology-*/*"]

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
    <<-EOS.undent
      To create a spatially-enabled database, see the documentation:
        http://postgis.net/docs/manual-2.2/postgis_installation.html#create_new_db_extensions
      If you are currently using PostGIS 2.0+, you can go the soft upgrade path:
        ALTER EXTENSION postgis UPDATE TO "#{version}";
      Users of 1.5 and below will need to go the hard-upgrade path, see here:
        http://postgis.net/docs/manual-2.2/postgis_installation.html#upgrading

      PostGIS SQL scripts installed to:
        #{opt_pkgshare}
      PostGIS plugin libraries installed to:
        #{HOMEBREW_PREFIX}/lib
      PostGIS extension modules installed to:
        #{HOMEBREW_PREFIX}/share/postgresql/extension
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
