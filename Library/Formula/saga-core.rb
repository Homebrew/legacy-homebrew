require 'formula'

class SagaCore < Formula
  homepage 'http://saga-project.org'
  url 'http://downloads.sourceforge.net/project/saga-gis/SAGA%20-%202.1/SAGA%202.1.0/saga_2.1.0.tar.gz'
  sha1 '1da4d7aed8ceb9efab9698b2c3bdb2670e65c5dd'

  head 'svn://svn.code.sf.net/p/saga-gis/code-0/trunk/saga-gis'

  depends_on 'boost'
  depends_on 'proj'
  depends_on 'gdal'
  depends_on 'wxmac'
  depends_on 'jasper'
  depends_on 'libharu' => :recommended
  depends_on 'wget'
  depends_on 'automake' => :build
  depends_on 'autoconf' => :build
  depends_on 'libtool' => :build

  def patches
  # Missing proj4 headers needed for compile
  # http://sourceforge.net/p/saga-gis/bugs/145/
  [ "https://gist.github.com/nickrobison/6559641/raw/",
  # Need to remove unsupported libraries from various Makefiles
  # http://sourceforge.net/apps/trac/saga-gis/wiki/Compiling%20SAGA%20on%20Mac%20OS%20X
  DATA ]
  end

  def install

    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOF.undent
    The SAGA GUI executable (saga_gui) is copied to  #{bin}.
    However, since it lacks an app bundle, it does not run properly.
    To create an app bundle, download the following script and icon file:

    http://web.fastermac.net/~MacPgmr/SAGA/create_saga_app.sh
    http://web.fastermac.net/~MacPgmr/SAGA/saga_gui.icns

    Run the following commands:

    chmod +x create_saga_app.sh
    ./create_saga_app.sh #{bin}/saga_gui SAGA

    This will create a SAGA.app bundle in the current directory for saga_gui.
    In Finder you can move this bundle to wherever you want.
    To start SAGA, double-click it in Finder.
    You can also drag and drop it on the Dock to start SAGA from there.
    Note that the SAGA GUI does not work very well yet.
    It has problems with creating a preferences file in the correct location and sometimes won't shut down (use Activity Monitor to force quit if necessary).

    For more info see:
    http://sourceforge.net/apps/trac/saga-gis/wiki/Compiling%20SAGA%20on%20Mac%20OS%20X
   EOF
  end
end

__END__
diff --git a/src/saga_core/saga_gui/Makefile.am b/src/saga_core/saga_gui/Makefile.am
index c1f3be7..3ace3fe 100644
--- a/src/saga_core/saga_gui/Makefile.am
+++ b/src/saga_core/saga_gui/Makefile.am
@@ -11,7 +11,7 @@ MSHAREPATH = "SHARE_PATH=\"$(prefix)/share/saga\""
 BASEFLAGS = -fPIC -D_SAGA_LINUX -D_TYPEDEF_BYTE -D_TYPEDEF_WORD -D_SAGA_DONOTUSE_HARU -D$(MLIBPATH) -D$(MSHAREPATH) $(DBGFLAGS) $(INCS)
 if SAGA_UNICODE
 AM_CXXFLAGS = $(BASEFLAGS) `wx-config --unicode=yes --cxxflags` -D_SAGA_UNICODE $(GOMPFLAGS)
-AM_LDFLAGS = -fPIC `wx-config --unicode=yes --libs adv,aui,base,core,html,net,propgrid,xml`
+AM_LDFLAGS = -fPIC `wx-config --unicode=yes --libs adv,core,html,net,xml`
 else
 AM_CXXFLAGS = $(BASEFLAGS) `wx-config --unicode=no --cxxflags` $(GOMPFLAGS)
 AM_LDFLAGS = -fPIC `wx-config --unicode=no --libs adv,aui,base,core,html,net,propgrid,xml`
diff --git a/src/saga_core/saga_odbc/Makefile.am b/src/saga_core/saga_odbc/Makefile.am
index 0613a37..03fdb1e 100644
--- a/src/saga_core/saga_odbc/Makefile.am
+++ b/src/saga_core/saga_odbc/Makefile.am
@@ -7,7 +7,7 @@ endif
 DEF_SAGA           = -D_SAGA_LINUX -D_TYPEDEF_BYTE -D_TYPEDEF_WORD
 CXX_INCS           = -I$(top_srcdir)/src/saga_core
 AM_CXXFLAGS        = $(CXX_INCS) $(DEF_SAGA) $(DEP_DEFS) $(DBGFLAGS) $(GOMPFLAGS)
-AM_LDFLAGS         = $(DEP_LFLG) -lodbc
+AM_LDFLAGS         = $(DEP_LFLG) -liodbc
 lib_LTLIBRARIES    = libsaga_odbc.la
 libsaga_odbc_la_LDFLAGS =$(AM_LDFLAGS) -release $(VERSION)
 libsaga_odbc_la_SOURCES =\

