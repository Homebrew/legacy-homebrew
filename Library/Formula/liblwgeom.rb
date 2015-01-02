class Liblwgeom < Formula
  homepage "http://postgis.net"

  stable do
    url "http://download.osgeo.org/postgis/source/postgis-2.1.5.tar.gz"
    sha1 "5ac24b95495be258a7430c08b3407d7beca1832a"

    # Strip all the PostgreSQL functions from PostGIS configure.ac, to allow
    # building liblwgeom.dylib without needing PostgreSQL
    # NOTE: this will need to be maintained per postgis version
    # Somehow, this still works for 2.1.5, which is awesome!
    patch do
      url "https://gist.githubusercontent.com/dakcarto/7458788/raw/8df39204eef5a1e5671828ded7f377ad0f61d4e1/postgis-config_strip-pgsql.diff"
      sha1 "3d93c9ede79439f1c683a604f9d906f5c788c690"
    end
  end

  bottle do
    cellar :any
    sha1 "c225e0bcc23cc38b026cde2b6ea8a1403ab09bcd" => :yosemite
    sha1 "077710818cff94dc707197dcc5794c49b67d080e" => :mavericks
    sha1 "6432a799ec96fd4583610f64c1ca88f3c5931fc4" => :mountain_lion
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
