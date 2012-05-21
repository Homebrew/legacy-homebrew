require 'formula'

def postgres?
    ARGV.include? "--with-postgres"
end

def mysql?
    ARGV.include? "--with-mysql"
end

def headless?
  # The GRASS GUI is based on WxPython. Unfortunately, Lion does not include
  # this module so we have to drop it.
  #
  # This restriction can be lifted once WxMac hits a stable release that is
  # 64-bit capable.
  ARGV.include? '--without-gui' or MacOS.lion?
end

class Grass < Formula
  homepage 'http://grass.osgeo.org/'
  url 'http://grass.osgeo.org/grass64/source/grass-6.4.2.tar.gz'
  md5 'd3398d6b1e3a2ef19cfb6e39a5ae9919'

  head 'https://svn.osgeo.org/grass/grass/trunk'

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "readline"
  depends_on "gdal"
  depends_on "libtiff"
  depends_on "unixodbc"
  depends_on "fftw"

  depends_on "cairo" if MacOS.leopard?

  # Patches ensure 32 bit system python is used for wxWidgets and that files
  # are not installed outside of the prefix.
  def patches; DATA; end

  fails_with :clang do
    build 318

    cause <<-EOS.undent
      Multiple build failures while compiling GRASS tools.
      EOS
  end

  def options
    [
      ['--with-postgres', 'Specify PostgreSQL as a dependency'],
      ['--with-mysql', 'Specify MySQL as a dependency'],
      ['--without-gui', 'Build without WxPython interface. Command line tools still available.']
    ]
  end

  def install
    readline = Formula.factory('readline')
    gettext = Formula.factory('gettext')

    args = [
      "--disable-debug", "--disable-dependency-tracking",
      "--with-libs=/usr/X11/lib #{HOMEBREW_PREFIX}/lib",
      "--with-includes=#{HOMEBREW_PREFIX}/include",
      "--enable-largefile",
      "--enable-shared",
      "--with-cxx",
      "--with-opengl=aqua",
      "--with-x",
      "--without-motif",
      "--with-python=/usr/bin/python-config",
      "--with-blas",
      "--with-lapack",
      "--with-sqlite",
      "--with-odbc",
      "--with-geos=#{HOMEBREW_PREFIX}/bin/geos-config",
      "--with-png-includes=/usr/X11/include",
      "--with-png",
      "--with-readline-includes=#{readline.include}",
      "--with-readline-libs=#{readline.lib}",
      "--with-readline",
      "--with-nls-includes=#{gettext.include}",
      "--with-nls-libs=#{gettext.lib}",
      "--with-nls",
      "--with-freetype-includes=/usr/X11/include /usr/X11/include/freetype2",
      "--with-freetype",
      "--without-tcltk" # Disabled due to compatibility issues with OS X Tcl/Tk
    ]

    if headless?
      args << "--without-wxwidgets"
    else
      args << "--with-wxwidgets=/usr/bin/wx-config"
    end

    if MacOS.prefer_64_bit?
      args << "--enable-64bit"
      args << "--with-macosx-archs=x86_64"
    else
      args << "--with-macosx-archs=i386"
    end

    # Deal with Cairo support
    if MacOS.leopard?
      cairo = Formula.factory('cairo')
      args << "--with-cairo-includes=#{cairo.include}/cairo"
      args << "--with-cairo-libs=#{cairo.lib}"
    else
      args << "--with-cairo-includes=/usr/X11/include /usr/X11/include/cairo"
    end

    args << "--with-cairo"

    # Database support
    args << "--with-postgres" if postgres?
    if mysql?
      mysql = Formula.factory('mysql')
      args << "--with-mysql-includes=#{mysql.include + 'mysql'}"
      args << "--with-mysql-libs=#{mysql.lib + 'mysql'}"
      args << "--with-mysql"
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make" # make and make install must be separate steps.
    system "make install"
  end

  def caveats
    if headless?
      <<-EOS.undent
        This build of GRASS has been compiled without the WxPython GUI. This is
        done by default on Lion because there is no stable build of WxPython
        available to compile against.

        The command line tools remain fully functional.
        EOS
    else
      <<-EOS.undent
        GRASS is currently in a transition period with respect to GUI support.
        The old Tcl/Tk GUI cannot be built using the version of Tcl/Tk provided
        by OS X.  This has the unfortunate consquence of disabling the NVIZ
        visualization system.  A keg-only Tcl/Tk brew or some deep hackery of
        the GRASS source may be possible ways to get around this around this.

        Tcl/Tk will eventually be depreciated in GRASS 7 and this version has
        been built to support the newer wxPython based GUI.  However, there is
        a problem as wxWidgets does not compile as a 64 bit library on OS X
        which affects Snow Leopard users.  In order to remedy this, the GRASS
        startup script:

          #{prefix}/grass-6.4.0/etc/Init.sh

        has been modified to use the OS X system Python and to start it in 32 bit mode.
        EOS
    end
  end
end

__END__
Patch 1:
Force 32-bit system Python to be used for the WxPython GUI.


diff --git a/lib/init/init.sh b/lib/init/init.sh
index 8c87fe1..2d1a2a3 100644
--- a/lib/init/init.sh
+++ b/lib/init/init.sh
@@ -27,6 +27,17 @@ trap "echo 'User break!' ; exit" 2 3 15
 # Set default GUI
 DEFAULT_GUI="wxpython"

+
+# Homebrew Additions:
+#
+# So, problem with wxWidgets is that the developers have not released a stable
+# version that builds x86_64 for OS X.  So, in order to use the nice GUI for
+# GRASS, we have to ensure the system python is used and ensure it starts in 32
+# bit mode.
+export VERSIONER_PYTHON_PREFER_32_BIT=yes
+export GRASS_PYTHON=/usr/bin/pythonw
+
+
 # the following is only meant to be an internal variable for debugging this script.
 #  use 'g.gisenv set="DEBUG=[0-5]"' to turn GRASS debug mode on properly.
 if [ -z "$GRASS_DEBUG" ] ; then


Patch 2:
Remove two lines of the Makefile that try to install stuff to
/Library/Documentation---which is outside of the prefix and usually fails due
to permissions issues.

diff --git a/Makefile b/Makefile
index f1edea6..be404b0 100644
--- a/Makefile
+++ b/Makefile
@@ -304,8 +304,6 @@ ifeq ($(strip $(MINGW)),)
 	-tar cBf - gem/skeleton | (cd ${INST_DIR}/etc ; tar xBf - ) 2>/dev/null
 	-${INSTALL} gem/gem$(GRASS_VERSION_MAJOR)$(GRASS_VERSION_MINOR) ${BINDIR} 2>/dev/null
 endif
-	@# enable OSX Help Viewer
-	@if [ "`cat include/Make/Platform.make | grep -i '^ARCH.*darwin'`" ] ; then /bin/ln -sfh "${INST_DIR}/docs/html" /Library/Documentation/Help/GRASS-${GRASS_VERSION_MAJOR}.${GRASS_VERSION_MINOR} ; fi
 
 
 install-strip: FORCE
