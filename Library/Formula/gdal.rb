require 'formula'

def complete?
  ARGV.include? "--complete"
end

def postgres?
  ARGV.include? "--with-postgres"
end

def mysql?
  ARGV.include? "--with-mysql"
end

def no_python?
  ARGV.include? "--without-python"
end

def opencl?
  ARGV.include? "--enable-opencl"
end

class Gdal < Formula
  url 'http://download.osgeo.org/gdal/gdal-1.8.1.tar.gz'
  homepage 'http://www.gdal.org/'
  md5 'b32269893afc9dc9eced45e74e4c6bb4'

  head 'https://svn.osgeo.org/gdal/trunk/gdal', :using => :svn

  depends_on 'jpeg'
  depends_on 'giflib'
  depends_on 'proj'
  depends_on 'geos'

  depends_on "postgresql" if postgres?
  depends_on "mysql" if mysql?

  if complete?
    # Raster libraries
    depends_on "netcdf" # Also brings in HDF5
    depends_on "jasper" # May need a keg-only GeoJasPer library as this one is
                        # not geo-spatially enabled.
    depends_on "cfitsio"
    depends_on "epsilon"

    # Vector libraries
    depends_on "unixodbc" # OS X version is not complete enough
    depends_on "libspatialite"
    depends_on "xerces-c"
    depends_on "poppler"

    # Other libraries
    depends_on "lzma"    # Compression algorithmn library
  end

  def patches
    if complete?
      # EPSILON v0.9.x slightly modified the naming of some struct members. A
      # fix is in the GDAL trunk but was kept out of 1.8.1 due to concern for
      # users of EPSILON v0.8.x. Homebrew installs 0.9.2+ so this concern is a
      # moot point.
      {:p1 => DATA}
    end
  end

  def options
    [
      ['--complete', 'Use additional Homebrew libraries to provide more drivers.'],
      ['--with-postgres', 'Specify PostgreSQL as a dependency.'],
      ['--with-mysql', 'Specify MySQL as a dependency.'],
      ['--without-python', 'Build without Python support (disables a lot of tools).'],
      ['--enable-opencl', 'Build with support for OpenCL.']
    ]
  end

  def get_configure_args
    args = [
      # Base configuration.
      "--disable-debug",
      "--with-local=#{prefix}",
      "--with-threads",
      "--with-libtool",

      # GDAL native backends.
      "--with-libtiff=internal", # For bigTIFF support
      "--with-geotiff=internal",
      "--with-pcraster=internal",
      "--with-pcidsk=internal",
      "--with-bsb",
      "--with-grib",
      "--with-pam",

      # Backends supported by OS X.
      "--with-libz=/usr",
      "--with-png=/usr/X11",
      "--with-expat=/usr",
      "--with-sqlite3=/usr",

      # Default Homebrew backends.
      "--with-jpeg=#{HOMEBREW_PREFIX}",
      "--with-jpeg12",
      "--with-gif=#{HOMEBREW_PREFIX}",
      "--with-curl=/usr/bin/curl-config",

      # GRASS backend explicitly disabled.  Creates a chicken-and-egg problem.
      # Should be installed seperately after GRASS installation using the
      # official GDAL GRASS plugin.
      "--without-grass",
      "--without-libgrass",

      # OPeNDAP support also explicitly disabled for now---causes the
      # configuration of other components such as Curl and Spatialite to fail
      # for unknown reasons.
      "--with-dods-root=no"

    ]

    # Optional library support for additional formats.
    if complete?
      args.concat [
        "--with-liblzma=yes",
        "--with-netcdf=#{HOMEBREW_PREFIX}",
        "--with-hdf5=#{HOMEBREW_PREFIX}",
        "--with-jasper=#{HOMEBREW_PREFIX}",
        "--with-cfitsio=#{HOMEBREW_PREFIX}",
        "--with-epsilon=#{HOMEBREW_PREFIX}",
        "--with-odbc=#{HOMEBREW_PREFIX}",
        "--with-spatialite=#{HOMEBREW_PREFIX}",
        "--with-xerces=#{HOMEBREW_PREFIX}",
        "--with-poppler=#{HOMEBREW_PREFIX}"
      ]
    else
      args.concat [
        "--without-cfitsio",
        "--without-netcdf",
        "--without-ogdi",
        "--without-hdf4",
        "--without-hdf5",
        "--without-openjpeg",
        "--without-jasper",
        "--without-xerces",
        "--without-epsilon",
        "--without-spatialite",
        "--without-libkml",
        "--without-poppler",

        # The following libraries are either proprietary or available under
        # non-free licenses.  Interested users will have to install such
        # software manually.
        "--without-msg",
        "--without-mrsid",
        "--without-jp2mrsid",
        "--without-kakadu",
        "--without-fme",
        "--without-ecw",
        "--without-dwgdirect"
      ]
    end

    # Database support.
    args << "--without-pg" unless postgres?
    args << "--without-mysql" unless mysql?
    args << "--without-sde"    # ESRI ArcSDE databases
    args << "--without-ingres" # Ingres databases
    args << "--without-oci"    # Oracle databases
    args << "--without-idb"    # IBM Informix DataBlades

    # Hombrew-provided databases.
    args << "--with-pg=#{HOMEBREW_PREFIX}/bin/pg_config" if postgres?
    args << "--with-mysql=#{HOMEBREW_PREFIX}/bin/mysql_config" if mysql?

    args << "--without-python" # Installed using a seperate set of
                                         # steps so that everything winds up
                                         # in the prefix.

    # Scripting APIs that have not been re-worked to respect Homebrew prefixes.
    #
    # Currently disabled as they install willy-nilly into locations outside of
    # the Hombrew prefix.  Enable if you feel like it, but uninstallation may be
    # a manual affair.
    #
    # TODO: Fix installation of script bindings so they install into the
    # Homebrew prefix.
    args << "--without-perl"
    args << "--without-php"
    args << "--without-ruby"

    # OpenCL support
    args << "--with-opencl" if opencl?

    return args
  end

  def install
    system "./configure", "--prefix=#{prefix}", *get_configure_args
    system "make"
    system "make install"

    unless no_python?
      # If setuptools happens to be installed, setup.py will cowardly refuse to
      # install to anywhere that is not on the PYTHONPATH.
      #
      # Really setuptools, we're all consenting adults here...
      python_lib = lib + "python"
      ENV.append 'PYTHONPATH', python_lib

      # setuptools is also apparently incapable of making the directory it's
      # self
      python_lib.mkpath

      # `python-config` may try to talk us into building bindings for more
      # architectures than we really should.
      if MacOS.prefer_64_bit?
        ENV.append_to_cflags '-arch x86_64'
      else
        ENV.append_to_cflags '-arch i386'
      end

      Dir.chdir 'swig/python' do
        system "python", "setup.py", "install_lib", "--install-dir=#{python_lib}"
        bin.install Dir['scripts/*']
      end
    end
  end

  unless no_python?
    def caveats
      <<-EOS
This version of GDAL was built with Python support.  In addition to providing
modules that makes GDAL functions available to Python scripts, the Python
binding provides ~18 additional command line tools.  However, both the Python
bindings and the additional tools will be unusable unless the following
directory is added to the PYTHONPATH:
    #{HOMEBREW_PREFIX}/lib/python
      EOS
    end
  end
end


__END__

This patch updates GDAL to be compatible with EPSILON 0.9.x. Changes sourced from the GDAL trunk:

    http://trac.osgeo.org/gdal/changeset/22363

Patch can be removed when GDAL hits 1.9.0.

diff --git a/frmts/epsilon/epsilondataset.cpp b/frmts/epsilon/epsilondataset.cpp
index b12928a..3f967cc 100644
--- a/frmts/epsilon/epsilondataset.cpp
+++ b/frmts/epsilon/epsilondataset.cpp
@@ -48,6 +48,13 @@ typedef struct
     vsi_l_offset offset;
 } BlockDesc;
 
+#ifdef I_WANT_COMPATIBILITY_WITH_EPSILON_0_8_1
+#define GET_FIELD(hdr, field) \
+    (hdr.block_type == EPS_GRAYSCALE_BLOCK) ? hdr.gs.field : hdr.tc.field
+#else
+#define GET_FIELD(hdr, field) \
+    (hdr.block_type == EPS_GRAYSCALE_BLOCK) ? hdr.hdr_data.gs.field : hdr.hdr_data.tc.field
+#endif
 
 /************************************************************************/
 /* ==================================================================== */
@@ -237,8 +244,8 @@ CPLErr EpsilonRasterBand::IReadBlock( int nBlockXOff,
         return CE_Failure;
     }
     
-    int w = (hdr.block_type == EPS_GRAYSCALE_BLOCK) ? hdr.gs.w : hdr.tc.w;
-    int h = (hdr.block_type == EPS_GRAYSCALE_BLOCK) ? hdr.gs.h : hdr.tc.h;
+    int w = GET_FIELD(hdr, w);
+    int h = GET_FIELD(hdr, h);
     int i;
 
     if (poGDS->nBands == 1)
@@ -505,12 +512,12 @@ int EpsilonDataset::ScanBlocks(int* pnBands)
             continue;
         }
         
-        int W = (hdr.block_type == EPS_GRAYSCALE_BLOCK) ? hdr.gs.W : hdr.tc.W;
-        int H = (hdr.block_type == EPS_GRAYSCALE_BLOCK) ? hdr.gs.H : hdr.tc.H;
-        int x = (hdr.block_type == EPS_GRAYSCALE_BLOCK) ? hdr.gs.x : hdr.tc.x;
-        int y = (hdr.block_type == EPS_GRAYSCALE_BLOCK) ? hdr.gs.y : hdr.tc.y;
-        int w = (hdr.block_type == EPS_GRAYSCALE_BLOCK) ? hdr.gs.w : hdr.tc.w;
-        int h = (hdr.block_type == EPS_GRAYSCALE_BLOCK) ? hdr.gs.h : hdr.tc.h;
+        int W = GET_FIELD(hdr, W);
+        int H = GET_FIELD(hdr, H);
+        int x = GET_FIELD(hdr, x);
+        int y = GET_FIELD(hdr, y);
+        int w = GET_FIELD(hdr, w);
+        int h = GET_FIELD(hdr, h);
 
         //CPLDebug("EPSILON", "W=%d,H=%d,x=%d,y=%d,w=%d,h=%d,offset=" CPL_FRMT_GUIB,
         //                    W, H, x, y, w, h, nStartBlockFileOff);
