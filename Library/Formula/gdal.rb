require 'formula'

class Gdal < Formula
  homepage 'http://www.gdal.org/'
  url 'http://download.osgeo.org/gdal/1.10.1/gdal-1.10.1.tar.gz'
  sha1 'b4df76e2c0854625d2bedce70cc1eaf4205594ae'
  revision 1

  bottle do
    sha1 "01dee8d333f89ba82165c2eb72816bafc687a308" => :mavericks
    sha1 "a57e4240a97c0f422c80d8e2b0e590ce6cb7ef62" => :mountain_lion
    sha1 "f90ec187f9b1acf1a55227b6fd91a47904165ba1" => :lion
  end

  head do
    url 'https://svn.osgeo.org/gdal/trunk/gdal'
    depends_on 'doxygen' => :build
  end

  option 'complete', 'Use additional Homebrew libraries to provide more drivers.'
  option 'enable-opencl', 'Build with OpenCL acceleration.'
  option 'enable-armadillo', 'Build with Armadillo accelerated TPS transforms.'
  option 'enable-unsupported', "Allow configure to drag in any library it can find. Invoke this at your own risk."
  option 'enable-mdb', 'Build with Access MDB driver (requires Java 1.6+ JDK/JRE, from Apple or Oracle).'

  depends_on :python => :recommended
  if build.with? "python"
    depends_on :fortran => :build
  end

  depends_on 'libpng'
  depends_on 'jpeg'
  depends_on 'giflib'
  depends_on 'libtiff'
  depends_on 'libgeotiff'
  depends_on 'proj'
  depends_on 'geos'

  depends_on 'sqlite' # To ensure compatibility with SpatiaLite.
  depends_on 'freexl'
  depends_on 'libspatialite'

  depends_on "postgresql" => :optional
  depends_on "mysql" => :optional

  depends_on 'homebrew/science/armadillo' if build.include? 'enable-armadillo'

  if build.include? 'complete'
    # Raster libraries
    depends_on "homebrew/science/netcdf" # Also brings in HDF5
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

  # Prevent build failure on 10.6 / 10.7: http://trac.osgeo.org/gdal/ticket/5197
  # Fix build against MySQL 5.6.x: http://trac.osgeo.org/gdal/ticket/5284
  patch :DATA

  stable do
    # Patch of configure that finds Mac Java for MDB driver (uses Oracle or Mac default JDK)
    # TODO: Remove when future GDAL release includes a fix
    # http://trac.osgeo.org/gdal/ticket/5267  (patch applied to trunk, 2.0 release milestone)
    # Must come before DATA
    patch do
      url "https://gist.githubusercontent.com/dakcarto/6877854/raw/82ae81e558c0b6048336f0acb5d7577bd0a237d5/gdal-mdb-patch.diff"
      sha1 "ea6c753df9e35abd90d7078f8a727eaab7f7d996"
    end if build.include? "enable-mdb"
  end

  resource 'numpy' do
    url 'http://downloads.sourceforge.net/project/numpy/NumPy/1.8.1/numpy-1.8.1.tar.gz'
    sha1 '8fe1d5f36bab3f1669520b4c7d8ab59a21a984da'
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
      "--with-png=#{Formula["libpng"].opt_prefix}",
      "--with-expat=/usr",
      "--with-curl=/usr/bin/curl-config",

      # Default Homebrew backends.
      "--with-jpeg=#{HOMEBREW_PREFIX}",
      "--without-jpeg12", # Needs specially configured JPEG and TIFF libraries.
      "--with-gif=#{HOMEBREW_PREFIX}",
      "--with-libtiff=#{HOMEBREW_PREFIX}",
      "--with-geotiff=#{HOMEBREW_PREFIX}",
      "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
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
    args << (build.with?("postgresql") ? "--with-pg=#{HOMEBREW_PREFIX}/bin/pg_config" : "--without-pg")
    args << (build.with?("mysql") ? "--with-mysql=#{HOMEBREW_PREFIX}/bin/mysql_config" : "--without-mysql")

    if build.include? 'enable-mdb'
      args << "--with-java=yes"
      # The rpath is only embedded for Oracle (non-framework) installs
      args << "--with-jvm-lib-add-rpath=yes"
      args << "--with-mdb=yes"
    end

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

  def install
    if build.with? 'python'
      ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
      numpy_args = [ "build", "--fcompiler=gnu95",
                     "install", "--prefix=#{libexec}" ]
      resource('numpy').stage { system "python", "setup.py", *numpy_args }
    end

    # Linking flags for SQLite are not added at a critical moment when the GDAL
    # library is being assembled. This causes the build to fail due to missing
    # symbols. Also, ensure Homebrew SQLite is used so that Spatialite is
    # functional.
    #
    # Fortunately, this can be remedied using LDFLAGS.
    sqlite = Formula["sqlite"]
    ENV.append 'LDFLAGS', "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.append 'CFLAGS', "-I#{sqlite.opt_include}"
    # Needed by libdap
    ENV.libxml2 if build.include? 'complete'

    # Reset ARCHFLAGS to match how we build.
    ENV['ARCHFLAGS'] = "-arch #{MacOS.preferred_arch}"

    # Fix hardcoded mandir: http://trac.osgeo.org/gdal/ticket/5092
    inreplace 'configure', %r[^mandir='\$\{prefix\}/man'$], ''

    system "./configure", *get_configure_args
    system "make"
    system "make install"

    # `python-config` may try to talk us into building bindings for more
    # architectures than we really should.
    if MacOS.prefer_64_bit?
      ENV.append_to_cflags "-arch #{Hardware::CPU.arch_64_bit}"
    else
      ENV.append_to_cflags "-arch #{Hardware::CPU.arch_32_bit}"
    end

    cd 'swig/python' do
      system "python", "setup.py", "install", "--prefix=#{prefix}", "--record=installed.txt", "--single-version-externally-managed"
      bin.install Dir['scripts/*']
    end

    system 'make', 'man' if build.head?
    system 'make', 'install-man'
    # Clean up any stray doxygen files.
    Dir[bin + '*.dox'].each { |p| rm p }
  end

  def caveats
    if build.include? 'enable-mdb'
      <<-EOS.undent

      To have a functional MDB driver, install supporting .jar files in:
        `/Library/Java/Extensions/`

      See: `http://www.gdal.org/ogr/drv_mdb.html`
      EOS
    end
  end
end

__END__
diff --git a/GDALmake.opt.in b/GDALmake.opt.in
index d7273aa..2fcbd53 100644
--- a/GDALmake.opt.in
+++ b/GDALmake.opt.in
@@ -123,6 +123,7 @@ INGRES_INC = @INGRES_INC@
 HAVE_MYSQL =	@HAVE_MYSQL@
 MYSQL_LIB  =	@MYSQL_LIB@
 MYSQL_INC  =	@MYSQL_INC@
+MYSQL_NEEDS_LOAD_DEFAULTS_DECLARATION  =    @MYSQL_NEEDS_LOAD_DEFAULTS_DECLARATION@
 LIBS	   +=	$(MYSQL_LIB)
 
 #
diff --git a/configure b/configure
index 1c4f8fb..120b17f 100755
--- a/configure
+++ b/configure
@@ -700,6 +700,7 @@ INGRES_INC
 INGRES_LIB
 II_SYSTEM
 HAVE_INGRES
+MYSQL_NEEDS_LOAD_DEFAULTS_DECLARATION
 MYSQL_LIB
 MYSQL_INC
 HAVE_MYSQL
@@ -23045,6 +23046,34 @@ $as_echo "no, mysql is pre-4.x" >&6; }
       MYSQL_INC="`$MYSQL_CONFIG --include`"
       { $as_echo "$as_me:${as_lineno-$LINENO}: result: yes" >&5
 $as_echo "yes" >&6; }
+
+      # Check if mysql headers declare load_defaults
+      { $as_echo "$as_me:${as_lineno-$LINENO}: checking load_defaults() in MySQL" >&5
+$as_echo_n "checking load_defaults() in MySQL... " >&6; }
+      rm -f testmysql.*
+      echo '#include "my_global.h"' > testmysql.cpp
+      echo '#include "my_sys.h"' >> testmysql.cpp
+      echo 'int main(int argc, char** argv) { load_defaults(0, 0, 0, 0); return 0; } ' >> testmysql.cpp
+      if test -z "`${CXX} ${CXXFLAGS} ${MYSQL_INC} -o testmysql testmysql.cpp ${MYSQL_LIB} 2>&1`" ; then
+        { $as_echo "$as_me:${as_lineno-$LINENO}: result: yes, found in my_sys.h" >&5
+$as_echo "yes, found in my_sys.h" >&6; }
+      else
+        echo 'extern "C" void load_defaults(const char *conf_file, const char **groups, int *argc, char ***argv);' > testmysql.cpp
+        echo 'int main(int argc, char** argv) { load_defaults(0, 0, 0, 0); return 0; } ' >> testmysql.cpp
+        if test -z "`${CXX} ${CXXFLAGS} ${MYSQL_INC} -o testmysql testmysql.cpp ${MYSQL_LIB} 2>&1`" ; then
+            { $as_echo "$as_me:${as_lineno-$LINENO}: result: yes, found in library but not in header" >&5
+$as_echo "yes, found in library but not in header" >&6; }
+            MYSQL_NEEDS_LOAD_DEFAULTS_DECLARATION=yes
+        else
+            HAVE_MYSQL=no
+            MYSQL_LIB=
+            MYSQL_INC=
+            as_fn_error $? "Cannot find load_defaults()" "$LINENO" 5
+        fi
+      fi
+      rm -f testmysql.*
+      rm -f testmysql
+
 	;;
   esac
 fi
@@ -23055,6 +23084,8 @@ MYSQL_INC=$MYSQL_INC
 
 MYSQL_LIB=$MYSQL_LIB
 
+MYSQL_NEEDS_LOAD_DEFAULTS_DECLARATION=$MYSQL_NEEDS_LOAD_DEFAULTS_DECLARATION
+
 
 
 
diff --git a/configure.in b/configure.in
index 481e8ea..d83797f 100644
--- a/configure.in
+++ b/configure.in
@@ -2294,6 +2294,31 @@ else
       MYSQL_LIB="`$MYSQL_CONFIG --libs`"
       MYSQL_INC="`$MYSQL_CONFIG --include`"
       AC_MSG_RESULT([yes])
+
+      # Check if mysql headers declare load_defaults
+      AC_MSG_CHECKING([load_defaults() in MySQL])
+      rm -f testmysql.*
+      echo '#include "my_global.h"' > testmysql.cpp
+      echo '#include "my_sys.h"' >> testmysql.cpp
+      echo 'int main(int argc, char** argv) { load_defaults(0, 0, 0, 0); return 0; } ' >> testmysql.cpp
+      if test -z "`${CXX} ${CXXFLAGS} ${MYSQL_INC} -o testmysql testmysql.cpp ${MYSQL_LIB} 2>&1`" ; then
+        AC_MSG_RESULT([yes, found in my_sys.h])
+      else
+        echo 'extern "C" void load_defaults(const char *conf_file, const char **groups, int *argc, char ***argv);' > testmysql.cpp
+        echo 'int main(int argc, char** argv) { load_defaults(0, 0, 0, 0); return 0; } ' >> testmysql.cpp
+        if test -z "`${CXX} ${CXXFLAGS} ${MYSQL_INC} -o testmysql testmysql.cpp ${MYSQL_LIB} 2>&1`" ; then
+            AC_MSG_RESULT([yes, found in library but not in header])
+            MYSQL_NEEDS_LOAD_DEFAULTS_DECLARATION=yes
+        else
+            HAVE_MYSQL=no
+            MYSQL_LIB=
+            MYSQL_INC=
+            AC_MSG_ERROR([Cannot find load_defaults()])
+        fi
+      fi
+      rm -f testmysql.*
+      rm -f testmysql
+
 	;;
   esac
 fi
@@ -2301,6 +2326,7 @@ fi
 AC_SUBST(HAVE_MYSQL,$HAVE_MYSQL)
 AC_SUBST(MYSQL_INC,$MYSQL_INC)
 AC_SUBST(MYSQL_LIB,$MYSQL_LIB)
+AC_SUBST(MYSQL_NEEDS_LOAD_DEFAULTS_DECLARATION,$MYSQL_NEEDS_LOAD_DEFAULTS_DECLARATION)
 
 dnl ---------------------------------------------------------------------------
 dnl INGRES support.
diff --git a/ogr/ogrsf_frmts/mysql/GNUmakefile b/ogr/ogrsf_frmts/mysql/GNUmakefile
index 292ae45..e78398d 100644
--- a/ogr/ogrsf_frmts/mysql/GNUmakefile
+++ b/ogr/ogrsf_frmts/mysql/GNUmakefile
@@ -7,6 +7,11 @@ OBJ	=	ogrmysqldriver.o ogrmysqldatasource.o \
 
 CPPFLAGS	:=	-I.. -I../.. $(GDAL_INCLUDE) $(MYSQL_INC) $(CPPFLAGS)
 
+ifeq ($(MYSQL_NEEDS_LOAD_DEFAULTS_DECLARATION),yes)
+CPPFLAGS +=   -DMYSQL_NEEDS_LOAD_DEFAULTS_DECLARATION
+endif
+
+
 default:	$(O_OBJ:.o=.$(OBJ_EXT))
 
 clean:
diff --git a/ogr/ogrsf_frmts/mysql/ogrmysqldatasource.cpp b/ogr/ogrsf_frmts/mysql/ogrmysqldatasource.cpp
index 65c275b..447e374 100644
--- a/ogr/ogrsf_frmts/mysql/ogrmysqldatasource.cpp
+++ b/ogr/ogrsf_frmts/mysql/ogrmysqldatasource.cpp
@@ -36,6 +36,16 @@
 #include "cpl_conv.h"
 #include "cpl_string.h"
 
+/* Recent versions of mysql no longer declare load_defaults() in my_sys.h */
+/* but they still have it in the lib. Very fragile... */
+#ifdef MYSQL_NEEDS_LOAD_DEFAULTS_DECLARATION
+extern "C" {
+int load_defaults(const char *conf_file, const char **groups,
+                  int *argc, char ***argv);
+void free_defaults(char **argv);
+}
+#endif
+
 CPL_CVSID("$Id: ogrmysqldatasource.cpp 24947 2012-09-22 09:54:23Z rouault $");
 /************************************************************************/
 /*                         OGRMySQLDataSource()                         */
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
