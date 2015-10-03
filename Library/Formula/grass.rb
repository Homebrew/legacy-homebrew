class Grass < Formula
  desc "Geographic Resources Analysis Support System"
  homepage "http://grass.osgeo.org/"
  revision 1

  stable do
    url "http://grass.osgeo.org/grass64/source/grass-6.4.4.tar.gz"
    sha256 "5ddba27b4e5495f602ee5249a07e287f342dd8e1422ea5d490c04311c731d274"

    # Patches that files are not installed outside of the prefix.
    patch :DATA
  end

  head do
    url "https://svn.osgeo.org/grass/grass/trunk"

    patch do
      url "https://gist.githubusercontent.com/jctull/0fe3db92a3e7c19fa6e0/raw/42e819f0a9b144de782c94f730dbc4da136e9227/grassPatchHead.diff"
      sha1 "ffbe31682d8a7605d5548cdafd536f1c785d3a23"
    end
  end

  option "without-gui", "Build without WxPython interface. Command line tools still available."

  depends_on :macos => :lion
  depends_on "gcc" if MacOS.version >= :mountain_lion
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "readline"
  depends_on "gdal"
  depends_on "libtiff"
  depends_on "unixodbc"
  depends_on "fftw"
  depends_on "wxpython" => :recommended # prefer over OS X's version because of 64bit
  depends_on :postgresql => :optional
  depends_on :mysql => :optional
  depends_on "cairo"
  depends_on "freetype"
  depends_on :x11  # needs to find at least X11/include/GL/gl.h

  fails_with :clang do
    cause "Multiple build failures while compiling GRASS tools."
  end

  def headless?
    # The GRASS GUI is based on WxPython. Unfortunately, Lion does not include
    # this module so we have to drop it.
    build.without?("gui") || MacOS.version == :lion
  end

  def install
    readline = Formula["readline"].opt_prefix
    gettext = Formula["gettext"].opt_prefix

    args = [
      "--disable-debug", "--disable-dependency-tracking",
      "--enable-largefile",
      "--enable-shared",
      "--with-cxx",
      "--without-motif",
      "--with-python",
      "--with-blas",
      "--with-lapack",
      "--with-sqlite",
      "--with-odbc",
      "--with-geos=#{Formula["geos"].opt_bin}/geos-config",
      "--with-png",
      "--with-readline-includes=#{readline}/include",
      "--with-readline-libs=#{readline}/lib",
      "--with-readline",
      "--with-nls-includes=#{gettext}/include",
      "--with-nls-libs=#{gettext}/lib",
      "--with-nls",
      "--with-freetype",
      "--without-tcltk" # Disabled due to compatibility issues with OS X Tcl/Tk
    ]

    unless MacOS::CLT.installed?
      # On Xcode-only systems (without the CLT), we have to help:
      args << "--with-macosx-sdk=#{MacOS.sdk_path}"
      args << "--with-opengl-includes=#{MacOS.sdk_path}/System/Library/Frameworks/OpenGL.framework/Headers"
    end

    if headless? || build.without?("wxmac")
      args << "--without-wxwidgets"
    else
      args << "--with-wxwidgets=#{Formula["wxmac"].opt_bin}/wx-config"
    end

    if build.with? "wxpython"
      python_site_packages = HOMEBREW_PREFIX/"lib/python2.7/site-packages"
      default_wx_path = File.read(python_site_packages/"wx.pth").strip
      ENV.prepend_path "PYTHONPATH", python_site_packages/default_wx_path
    end

    args << "--enable-64bit" if MacOS.prefer_64_bit?
    args << "--with-macos-archs=#{MacOS.preferred_arch}"

    cairo = Formula["cairo"]
    args << "--with-cairo-includes=#{cairo.include}/cairo"
    args << "--with-cairo-libs=#{cairo.lib}"
    args << "--with-cairo"

    # Database support
    args << "--with-postgres" if build.with? "postgresql"

    if build.with? "mysql"
      mysql = Formula["mysql"]
      args << "--with-mysql-includes=#{mysql.include}/mysql"
      args << "--with-mysql-libs=#{mysql.lib}"
      args << "--with-mysql"
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make GDAL_DYNAMIC=" # make and make install must be separate steps.
    system "make GDAL_DYNAMIC= install" # GDAL_DYNAMIC set to blank for r.external compatability
  end

  def caveats
    if headless?
      <<-EOS.undent
        This build of GRASS has been compiled without the WxPython GUI. This is
        done by default on Lion because there is no stable build of WxPython
        available to compile against.

        The command line tools remain fully functional.
        EOS
    elsif MacOS.version < :lion
      # On Lion or above, we are very happy with our brewed wxwidgets.
      <<-EOS.undent
        GRASS is currently in a transition period with respect to GUI support.
        The old Tcl/Tk GUI cannot be built using the version of Tcl/Tk provided
        by OS X. This has the unfortunate consquence of disabling the NVIZ
        visualization system. A keg-only Tcl/Tk brew or some deep hackery of
        the GRASS source may be possible ways to get around this.

        Tcl/Tk will eventually be deprecated in GRASS 7 and this version has
        been built to support the newer wxPython based GUI. However, there is
        a problem as wxWidgets does not compile as a 64 bit library on OS X
        which affects Snow Leopard users. In order to remedy this, the GRASS
        startup script:

          #{prefix}/grass-#{version}/etc/Init.sh

        has been modified to use the OS X system Python and to start it in 32 bit mode.
        EOS
    end
  end
end

__END__
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
