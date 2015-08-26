class Liblwgeom < Formula
  desc "Allows SpatiaLite to support ST_MakeValid() like PostGIS"
  homepage "http://postgis.net"
  revision 1

  stable do
    url "http://download.osgeo.org/postgis/source/postgis-2.1.5.tar.gz"
    sha256 "0d0e27f72f12b8dba456fbde25ed0f6913f42baf57332a7f1b9bbc6f29fddbf4"
    # Strip all the PostgreSQL functions from PostGIS configure.ac, to allow
    # building liblwgeom.dylib without needing PostgreSQL
    # NOTE: this will need to be maintained per postgis version
    # Somehow, this still works for 2.1.5, which is awesome!
    patch do
      url "https://gist.githubusercontent.com/dakcarto/7458788/raw/8df39204eef5a1e5671828ded7f377ad0f61d4e1/postgis-config_strip-pgsql.diff"
      sha256 "0bccd1a9b42d8ef537a3851392e378ee252f813464a91ab8fe21ff7f7cae20c1"
    end
  end

  bottle do
    cellar :any
    sha256 "48aa3296e32ff2a72c2c559649a37e7ad1ce3c8fe825d9a0f3e320683c97041e" => :yosemite
    sha256 "c2a7148e99fe6b03f368a12bf89e69262795e97c1d8b1578f250607bf8833136" => :mavericks
    sha256 "11a77a99a93daed092be094195bc1afce3f2c2d91adc9412106bf5c89e4f5755" => :mountain_lion
  end

  head do
    url "http://svn.osgeo.org/postgis/trunk/"
    depends_on "postgresql" => :build # don't maintain patches for HEAD
  end

  keg_only "Conflicts with PostGIS, which also installs liblwgeom.dylib"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gpp" => :build

  depends_on "proj"
  depends_on "geos"
  depends_on "json-c"

  def install
    # See postgis.rb for comments about these settings
    ENV.deparallelize

    args = [
      "--disable-dependency-tracking",
      "--disable-nls",

      "--with-projdir=#{HOMEBREW_PREFIX}",
      "--with-jsondir=#{Formula["json-c"].opt_prefix}",

      # Disable extraneous support
      "--without-libiconv-prefix",
      "--without-libintl-prefix",
      "--without-raster", # this ensures gdal is not required
      "--without-topology"
    ]

    if build.head?
      args << "--with-pgconfig=#{Formula["postgresql"].opt_bin}/pg_config"
    end

    system "./autogen.sh"
    system "./configure", *args

    mkdir "stage"
    cd "liblwgeom" do
      system "make", "install", "DESTDIR=#{buildpath}/stage"
    end

    lib.install Dir["stage/**/lib/*"]
    include.install Dir["stage/**/include/*"]
  end
end
