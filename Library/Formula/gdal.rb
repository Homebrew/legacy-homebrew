require 'formula'

class Gdal < Formula
  homepage 'http://www.gdal.org/'
  url 'http://download.osgeo.org/gdal/1.10.1/gdal-1.10.1.tar.gz'
  sha1 'b4df76e2c0854625d2bedce70cc1eaf4205594ae'

  head do
    url 'https://svn.osgeo.org/gdal/trunk/gdal'
    depends_on 'doxygen' => :build
  end

  option 'complete', 'Use additional Homebrew libraries to provide more drivers.'
  option 'with-postgres', 'Specify PostgreSQL as a dependency.'
  option 'with-mysql', 'Specify MySQL as a dependency.'
  option 'enable-opencl', 'Build with OpenCL acceleration.'
  option 'enable-armadillo', 'Build with Armadillo accelerated TPS transforms.'
  option 'enable-unsupported', "Allow configure to drag in any library it can find. Invoke this at your own risk."

  depends_on :python => :recommended
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

  depends_on "postgresql" => :optional
  depends_on "mysql" => :optional

  # Without Numpy, the Python bindings can't deal with raster data.
  depends_on 'numpy' => :python if build.with? 'python'

  depends_on 'homebrew/science/armadillo' if build.include? 'enable-armadillo'

  if build.include? 'complete'
    # Raster libraries
    depends_on "netcdf" # Also brings in HDF5
    depends_on "jasper"
    depends_on "webp"
    depends_on "cfitsio"
    depends_on "epsilon"
    depends_on "libdap"

    # Vector libraries
    depends_on "unixodbc" # OS X version is not complete enough
    depends_on "xerces-c"

    # Other libraries
    depends_on "xz" # get liblzma compression algorithm library from XZutils
    depends_on "poppler"
  end

  def png_prefix
    MacOS.version >= :mountain_lion ? HOMEBREW_PREFIX/"opt/libpng" : MacOS::X11.prefix
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
      "--with-png=#{png_prefix}",
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
    if build.include? 'complete'
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
    args << (build.with?("postgres") ? "--with-pg=#{HOMEBREW_PREFIX}/bin/pg_config" : "--without-pg")
    args << (build.with?("mysql") ? "--with-mysql=#{HOMEBREW_PREFIX}/bin/mysql_config" : "--without-mysql")

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

    args << (build.include?("enable-opencl") ? "--with-opencl" : "--without-opencl")
    args << (build.include?("enable-armadillo") ? "--with-armadillo=yes" : "--with-armadillo=no")

    return args
  end

  def patches
    # Prevent build failure on 10.6 / 10.7
    # TODO: Remove when 1.10.2 releases
    # http://trac.osgeo.org/gdal/ticket/5197
    DATA
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
    ENV.append 'CFLAGS', "-I#{sqlite.opt_prefix}/include"
    # Needed by libdap.
    ENV.libxml2 if build.include? 'complete'

    # Reset ARCHFLAGS to match how we build.
    ENV['ARCHFLAGS'] = "-arch #{MacOS.preferred_arch}"

    # Fix hardcoded mandir: http://trac.osgeo.org/gdal/ticket/5092
    inreplace 'configure', %r[^mandir='\$\{prefix\}/man'$], ''

    system "./configure", *get_configure_args
    system "make"
    system "make install"

    python do
      # `python-config` may try to talk us into building bindings for more
      # architectures than we really should.
      if MacOS.prefer_64_bit?
        ENV.append_to_cflags "-arch #{Hardware::CPU.arch_64_bit}"
      else
        ENV.append_to_cflags "-arch #{Hardware::CPU.arch_32_bit}"
      end

      cd 'swig/python' do
        system python, "setup.py", "install", "--prefix=#{prefix}", "--record=installed.txt", "--single-version-externally-managed"
        bin.install Dir['scripts/*']
      end
    end

    system 'make', 'man' if build.head?
    system 'make', 'install-man'
    # Clean up any stray doxygen files.
    Dir[bin + '*.dox'].each { |p| rm p }
  end

  def caveats
    if python
      python.standard_caveats +
      <<-EOS.undent
        This version of GDAL was built with Python support. In addition to providing
        modules that makes GDAL functions available to Python scripts, the Python
        binding provides ~18 additional command line tools.
      EOS
    end
  end
end

__END__
diff --git a/port/cpl_spawn.cpp b/port/cpl_spawn.cpp
index d702594..69ea3c2 100644
--- a/port/cpl_spawn.cpp
+++ b/port/cpl_spawn.cpp
@@ -464,7 +464,7 @@ void CPLSpawnAsyncCloseErrorFileHandle(CPLSpawnedProcess* p)
     #ifdef __APPLE__
         #include <TargetConditionals.h>
     #endif
-    #if defined(__APPLE__) && !defined(TARGET_OS_IPHONE)
+    #if defined(__APPLE__) && (!defined(TARGET_OS_IPHONE) || TARGET_OS_IPHONE==0)
         #include <crt_externs.h>
         #define environ (*_NSGetEnviron())
     #else
