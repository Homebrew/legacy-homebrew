require 'formula'

class SagaGis < Formula
  homepage 'http://saga-gis.org'
  url 'http://downloads.sourceforge.net/project/saga-gis/SAGA%20-%202.1/SAGA%202.1.1/saga_2.1.1.tar.gz'
  sha1 '40ac4d0646e04187aa6728181c3954993e51dcd5'

  head 'svn://svn.code.sf.net/p/saga-gis/code-0/trunk/saga-gis'

  option "with-app", "Build SAGA.app Package"

  depends_on :automake
  depends_on :autoconf
  depends_on :libtool
  depends_on 'gdal'
  depends_on 'jasper'
  depends_on 'proj'
  depends_on 'wxmac'
  depends_on 'unixodbc' => :recommended
  depends_on 'libharu' => :recommended
  depends_on 'postgresql' => :optional
  depends_on :python => :optional

  def patches
    # Compiling on Mavericks with libc++ causes issues with LC_NUMERIC.
    # https://sourceforge.net/p/saga-gis/patches/12/
    # Fixes issue with libio_grid.dylib. Thanks @dakcarto
    DATA
  end

  resource 'app_icon' do
    url 'http://web.fastermac.net/~MacPgmr/SAGA/saga_gui.icns'
    sha1 '1ff67c6d600dd161684d3e8b33a1d138c65b00f4'
  end

  resource 'projects' do
    url 'http://trac.osgeo.org/proj/export/2409/branches/4.8/proj/src/projects.h'
    sha1 '867367a8ef097d5ff772b7f50713830d2d4bc09c'
    version '4.8.0'
  end

  def install
    (buildpath/'src/modules_projection/pj_proj4/pj_proj4/').install resource('projects')

    # Need to remove unsupported libraries from various Makefiles
    # http://sourceforge.net/apps/trac/saga-gis/wiki/Compiling%20SAGA%20on%20Mac%20OS%20X
    inreplace "src/saga_core/saga_gui/Makefile.am", "aui,base,", ""
    inreplace "src/saga_core/saga_gui/Makefile.am", "propgrid,", ""

    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
      "--disable-openmp"

      ]

    args << "--disable-odbc" if build.without? "unixodbc"
    args << "--with-postgresql" if build.with? "postgresql"
    args << "--with-python" if build.with? "python"

    system "autoreconf", "-i"
    system "./configure", *args
    system "make install"

    if build.include? "with-app"
      # Based on original script by Phil Hess
      # http://web.fastermac.net/~MacPgmr/

      (buildpath).install resource('app_icon')
      mkdir_p "#{buildpath}/SAGA.app/Contents/MacOS"
      mkdir_p "#{buildpath}/SAGA.app/Contents/Resources"

      (buildpath/'SAGA.app/Contents/PkgInfo').write 'APPLSAGA'
      cp "#{buildpath}/saga_gui.icns", "#{buildpath}/SAGA.app/Contents/Resources/"
      ln_s "#{bin}/saga_gui", "#{buildpath}/SAGA.app/Contents/MacOS/saga_gui"

      config = <<-EOS.undent
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>CFBundleDevelopmentRegion</key>
          <string>English</string>
          <key>CFBundleExecutable</key>
          <string>saga_gui</string>
          <key>CFBundleIconFile</key>
          <string>saga_gui.icns</string>
          <key>CFBundleInfoDictionaryVersion</key>
          <string>6.0</string>
          <key>CFBundleName</key>
          <string>SAGA</string>
          <key>CFBundlePackageType</key>
          <string>APPL</string>
          <key>CFBundleSignature</key>
          <string>SAGA</string>
          <key>CFBundleVersion</key>
          <string>1.0</string>
          <key>CSResourcesFileMapped</key>
          <true/>
        </dict>
        </plist>
    EOS

    (buildpath/'SAGA.app/Contents/Info.plist').write config
    prefix.install "SAGA.app"

    end
  end

  def caveats
    if build.include? "with-app" then <<-EOS.undent
      SAGA.app was installed in:
        #{prefix}

      To symlink into ~/Applications, you can do:
        brew linkapps

      Note that the SAGA GUI does not work very well yet.
      It has problems with creating a preferences file in the correct location and sometimes won't shut down (use Activity Monitor to force quit if necessary).
      EOS
    end
  end
end

__END__
diff --git a/src/saga_core/saga_cmd/saga_cmd.cpp b/src/saga_core/saga_cmd/saga_cmd.cpp
index 0ce6d36..9f554a8 100644
--- a/src/saga_core/saga_cmd/saga_cmd.cpp
+++ b/src/saga_core/saga_cmd/saga_cmd.cpp
@@ -67,6 +67,7 @@
 #include "callback.h"
 
 #include "module_library.h"
+#include <locale.h>
 
 
 ///////////////////////////////////////////////////////////
 diff --git a/src/modules_io/grid/io_grid/xyz.h b/src/modules_io/grid/io_grid/xyz.h
index ffbd194..33b62fd 100644
--- a/src/modules_io/grid/io_grid/xyz.h
+++ b/src/modules_io/grid/io_grid/xyz.h
@@ -86,6 +86,7 @@ class CXYZ_Export : public CSG_Module_Grid
 {
 public:
 	CXYZ_Export(void);
+	virtual ~CXYZ_Export(void);

 	virtual CSG_String		Get_MenuPath	(void)			{	return( _TL("R:Export") );	}

