require 'formula'

def complete?
  build.include? 'complete'
end

def postgres?
  build.include? 'with-postgres'
end

def mysql?
  build.include? 'with-mysql'
end

def no_python?
  build.include? 'without-python'
end

def which_python
  "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
end

def opencl?
  build.include? 'enable-opencl'
end

def armadillo?
  build.include? 'enable-armadillo'
end


class Gdal < Formula
  homepage 'http://www.gdal.org/'
  url 'http://download.osgeo.org/gdal/gdal-1.9.2.tar.gz'
  sha1 '7eda6a4d735b8d6903740e0acdd702b43515e351'

  head 'https://svn.osgeo.org/gdal/trunk/gdal'

  option 'complete', 'Use additional Homebrew libraries to provide more drivers.'
  option 'with-postgres', 'Specify PostgreSQL as a dependency.'
  option 'with-mysql', 'Specify MySQL as a dependency.'
  option 'without-python', 'Build without Python support (disables a lot of tools).'
  option 'enable-opencl', 'Build with OpenCL acceleration.'
  option 'enable-armadillo', 'Build with Armadillo accelerated TPS transforms.'
  option 'enable-unsupported', "Allow configure to drag in any library it can find. Invoke this at your own risk."

  # For creating up to date man pages.
  depends_on 'doxygen' => :build if build.head?

  depends_on :libpng
  depends_on 'jpeg'
  depends_on 'giflib'
  depends_on 'libtiff'
  depends_on 'libgeotiff'
  depends_on 'proj'
  depends_on 'geos'

  depends_on 'sqlite'  # To ensure compatibility with SpatiaLite.
  depends_on 'freexl'
  depends_on 'libspatialite'

  depends_on "postgresql" if postgres?
  depends_on "mysql" if mysql?

  # Without Numpy, the Python bindings can't deal with raster data.
  depends_on 'numpy' => :python unless no_python?

  depends_on 'armadillo' if armadillo?

  if complete?
    # Raster libraries
    depends_on "netcdf" # Also brings in HDF5
    depends_on "jasper"
    depends_on "webp"
    depends_on "cfitsio"
    depends_on "epsilon"
    depends_on "libdap"
    # Fix a bug in LibDAP detection: http://trac.osgeo.org/gdal/ticket/4630
    def patches; DATA; end unless build.head?

    # Vector libraries
    depends_on "unixodbc" # OS X version is not complete enough
    depends_on "xerces-c"

    # Other libraries
    depends_on "xz" # get liblzma compression algorithm library from XZutils
    depends_on "poppler"
  end

  def get_configure_args
    args = [
      # Base configuration.
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      "--disable-debug",
      "--with-local=#{prefix}",
      "--with-threads",
      "--with-libtool",

      # GDAL native backends.
      "--with-pcraster=internal",
      "--with-pcidsk=internal",
      "--with-bsb",
      "--with-grib",
      "--with-pam",

      # Backends supported by OS X.
      "--with-libiconv-prefix=/usr",
      "--with-libz=/usr",
      "--with-png=#{(MacOS.version >= :mountain_lion) ? HOMEBREW_PREFIX : MacOS::X11.prefix}",
      "--with-expat=/usr",
      "--with-curl=/usr/bin/curl-config",

      # Default Homebrew backends.
      "--with-jpeg=#{HOMEBREW_PREFIX}",
      "--without-jpeg12", # Needs specially configured JPEG and TIFF libraries.
      "--with-gif=#{HOMEBREW_PREFIX}",
      "--with-libtiff=#{HOMEBREW_PREFIX}",
      "--with-geotiff=#{HOMEBREW_PREFIX}",
      "--with-sqlite3=#{Formula.factory('sqlite').opt_prefix}",
      "--with-freexl=#{HOMEBREW_PREFIX}",
      "--with-spatialite=#{HOMEBREW_PREFIX}",
      "--with-geos=#{HOMEBREW_PREFIX}/bin/geos-config",
      "--with-static-proj4=#{HOMEBREW_PREFIX}",

      # GRASS backend explicitly disabled.  Creates a chicken-and-egg problem.
      # Should be installed separately after GRASS installation using the
      # official GDAL GRASS plugin.
      "--without-grass",
      "--without-libgrass"
    ]

    # Optional Homebrew packages supporting additional formats.
    supported_backends = %w[
      liblzma
      cfitsio
      hdf5
      netcdf
      jasper
      xerces
      odbc
      dods-root
      epsilon
      webp
      poppler
    ]
    if complete?
      supported_backends.delete 'liblzma'
      args << '--with-liblzma=yes'
      args.concat supported_backends.map {|b| '--with-' + b + '=' + HOMEBREW_PREFIX}
    else
      args.concat supported_backends.map {|b| '--without-' + b} unless build.include? 'enable-unsupported'
    end

    # The following libraries are either proprietary, not available for public
    # download or have no stable version in the Homebrew core that is
    # compatible with GDAL. Interested users will have to install such software
    # manually and most likely have to tweak the install routine.
    #
    # Podofo is disabled because Poppler provides the same functionality and
    # then some.
    unsupported_backends = %w[
      gta
      ogdi
      fme
      hdf4
      openjpeg
      fgdb
      ecw
      kakadu
      mrsid
      jp2mrsid
      mrsid_lidar
      msg
      oci
      ingres
      libkml
      dwgdirect
      idb
      sde
      podofo
      rasdaman
    ]
    args.concat unsupported_backends.map {|b| '--without-' + b} unless build.include? 'enable-unsupported'

    # Database support.
    args << (postgres? ? "--with-pg=#{HOMEBREW_PREFIX}/bin/pg_config" : '--without-pg')
    args << (mysql? ? "--with-mysql=#{HOMEBREW_PREFIX}/bin/mysql_config" : '--without-mysql')

    # Python is installed manually to ensure everything is properly sandboxed.
    args << '--without-python'

    # Scripting APIs that have not been re-worked to respect Homebrew prefixes.
    #
    # Currently disabled as they install willy-nilly into locations outside of
    # the Homebrew prefix.  Enable if you feel like it, but uninstallation may be
    # a manual affair.
    #
    # TODO: Fix installation of script bindings so they install into the
    # Homebrew prefix.
    args << "--without-perl"
    args << "--without-php"
    args << "--without-ruby"

    args << (opencl? ? '--with-opencl' : '--without-opencl')
    args << (armadillo? ? '--with-armadillo=yes' : '--with-armadillo=no')

    return args
  end

  def install
    # Linking flags for SQLite are not added at a critical moment when the GDAL
    # library is being assembled. This causes the build to fail due to missing
    # symbols. Also, ensure Homebrew SQLite is used so that Spatialite is
    # functional.
    #
    # Fortunately, this can be remedied using LDFLAGS.
    sqlite = Formula.factory 'sqlite'
    ENV.append 'LDFLAGS', "-L#{sqlite.opt_prefix}/lib -lsqlite3"
    # Needed by libdap.
    ENV.append 'CPPFLAGS', '-I/usr/include/libxml2' if complete?

    # Reset ARCHFLAGS to match how we build.
    if MacOS.prefer_64_bit?
      ENV['ARCHFLAGS'] = "-arch x86_64"
    else
      ENV['ARCHFLAGS'] = "-arch i386"
    end

    system "./configure", *get_configure_args
    system "make"
    system "make install"

    unless no_python?
      # If setuptools happens to be installed, setup.py will cowardly refuse to
      # install to anywhere that is not on the PYTHONPATH.
      #
      # Really setuptools, we're all consenting adults here...
      python_lib = lib + which_python + 'site-packages'
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

      cd 'swig/python' do
        system "python", "setup.py", "install_lib", "--install-dir=#{python_lib}"
        bin.install Dir['scripts/*']
      end
    end

    system 'make', 'man' if build.head?
    system 'make', 'install-man'
    # Clean up any stray doxygen files.
    Dir[bin + '*.dox'].each { |p| rm p }
  end

  unless no_python?
    def caveats
      <<-EOS
This version of GDAL was built with Python support.  In addition to providing
modules that makes GDAL functions available to Python scripts, the Python
binding provides ~18 additional command line tools.

Unless you are using Homebrew's Python, both the bindings and the
additional tools will be unusable unless the following directory is added to
the PYTHONPATH:

    #{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages
      EOS
    end
  end
end

__END__
Fix test for LibDAP >= 3.10.


diff --git a/configure b/configure
index 997bbbf..a1928d5 100755
--- a/configure
+++ b/configure
@@ -24197,7 +24197,7 @@ else
 rm -f islibdappost310.*
 echo '#include "Connect.h"' > islibdappost310.cpp
 echo 'int main(int argc, char** argv) { return 0; } ' >> islibdappost310.cpp
-if test -z "`${CXX} islibdappost310.cpp -c ${DODS_INC} 2>&1`" ; then
+if test -z "`${CXX} islibdappost310.cpp -c ${DODS_INC} ${CPPFLAGS} 2>&1`" ; then
     DODS_INC="$DODS_INC -DLIBDAP_310 -DLIBDAP_39"
     { $as_echo "$as_me:${as_lineno-$LINENO}: result: libdap >= 3.10" >&5
 $as_echo "libdap >= 3.10" >&6; }
