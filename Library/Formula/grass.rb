require 'formula'

def postgres?
    ARGV.include? "--with-postgres"
end

def mysql?
    ARGV.include? "--with-mysql"
end

class Grass < Formula
  homepage 'http://grass.osgeo.org/'
  url 'http://grass.osgeo.org/grass64/source/grass-6.4.1.tar.gz'
  md5 'd8ca83d416b5b0cf2aa9d36c81a77b23'
  head 'https://svn.osgeo.org/grass/grass/trunk', :using => :svn

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "readline"
  depends_on "gdal"
  depends_on "libtiff"
  depends_on "unixodbc"
  depends_on "fftw"

  depends_on "cairo" if MacOS.leopard?

  def patches
    DATA
  end

  def options
    [
      ['--with-postgres', 'Specify PostgreSQL as a dependency'],
      ['--with-mysql', 'Specify MySQL as a dependency']
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
      "--with-wxwidgets=/usr/bin/wx-config",
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
    system "make" # make and make install must be seperate steps.
    system "make install"
  end

  def caveats
    caveats = <<-EOS
GRASS is currently in a transition period with respect to GUI support.  The old
Tcl/Tk GUI cannot be built using the version of Tcl/Tk provided by OS X.  This
has the unfortunate consquence of disabling the NVIZ visualization system.  A
keg-only Tcl/Tk brew or some deep hackery of the GRASS source may be possible
ways to get around this around this.

Tcl/Tk will eventually be depreciated in GRASS 7 and this version has been built
to support the newer wxPython based GUI.  However, there is a problem as
wxWidgets does not compile as a 64 bit library on OS X which affects Snow
Leopard users.  In order to remedy this, the GRASS startup script:

    #{prefix}/grass-6.4.0/etc/Init.sh

has been modified to use the OS X system Python and to start it in 32 bit mode.
    EOS
  end
end

__END__
Patch to ensure 32 bit system python is used for wxWidgets

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
