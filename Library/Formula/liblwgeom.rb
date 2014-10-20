require 'formula'

class Liblwgeom < Formula
  homepage 'http://postgis.net'

  stable do
    url "http://download.osgeo.org/postgis/source/postgis-2.1.1.tar.gz"
    sha1 "eaff009fb22b8824f89e5aa581e8b900c5d8f65b"

      # Strip all the PostgreSQL functions from PostGIS configure.ac, to allow
      # building liblwgeom.dylib without needing PostgreSQL
      # NOTE: this will need to be maintained per postgis version
    patch do
      url "https://gist.githubusercontent.com/dakcarto/7458788/raw/8df39204eef5a1e5671828ded7f377ad0f61d4e1/postgis-config_strip-pgsql.diff"
      sha1 "3d93c9ede79439f1c683a604f9d906f5c788c690"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha1 "064733dceb874e5a0adb5ec66b943af3694b7dfd" => :yosemite
    sha1 "63e0c7f24359169788ad34bdaa80c5795af5cee1" => :mavericks
    sha1 "3b1a0aae4a0dc0446c1cf8f626ed0b4156fd906c" => :mountain_lion
  end

  head do
    url 'http://svn.osgeo.org/postgis/trunk/'
    depends_on 'postgresql' => :build # don't maintain patches for HEAD
  end

  keg_only "Conflicts with PostGIS, which also installs liblwgeom.dylib"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on 'gpp' => :build

  depends_on 'proj'
  depends_on 'geos'
  depends_on 'json-c'

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
      args << "--with-pgconfig=#{Formula["postgresql"].opt_prefix.realpath}/bin/pg_config"
    end

    system './autogen.sh'
    system './configure', *args

    mkdir 'stage'
    cd 'liblwgeom' do
      system 'make', 'install', "DESTDIR=#{buildpath}/stage"
    end

    # NOTE: lib.install Dir['stage/**/lib/*'] fails (symlink is not resolved)
    prefix.install Dir["stage/**/lib"]
    include.install Dir["stage/**/include/*"]
  end
end
