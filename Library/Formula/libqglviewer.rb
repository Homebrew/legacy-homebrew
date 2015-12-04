class Libqglviewer < Formula
  desc "C++ Qt library to create OpenGL 3D viewers"
  homepage "http://www.libqglviewer.com/"
  url "http://www.libqglviewer.com/src/libQGLViewer-2.6.1.tar.gz"
  sha256 "9312c1a3d7fcf60ffc0bb1c8588b223034b06dab8f7e203f1a7e4ebc9b846c16"

  head "https://github.com/GillesDebunne/libQGLViewer.git"

  bottle do
    cellar :any
    sha256 "4e10d8f4fc3dd26fdecf2ea84eb7f9d4ce31de6ed0bf32827c5f2c2c3467e3f0" => :el_capitan
    sha256 "e38fbb01b02b961a242b56340cc1d2f3010b64ea21c8c7caf5c20dee077ea505" => :yosemite
    sha256 "0c866f4fb472474fda0054a4fd7b3c54500a2c076e0699179da8d2614ccf94a1" => :mavericks
    sha256 "d43ff135e46f0032759e33c8f42da2c0c306e3c5bdeacb09f79fe082196ece7a" => :mountain_lion
  end

  option :universal

  depends_on "qt"

  # This patches makes the package install QGLViewer.framework under
  # #{lib}, where it will be picked by homebrew.
  # Patch has been submitted to the developer, check with versions
  # newer than 2.6.1 if this is still required.
  patch :DATA

  def install
    args = ["PREFIX=#{prefix}"]
    args << "CONFIG += x86 x86_64" if build.universal?

    cd "QGLViewer" do
      system "qmake", *args
      system "make"
    end
  end
end

__END__
diff --git a/QGLViewer/QGLViewer.pro b/QGLViewer/QGLViewer.pro
index d805aa0..736a58f 100644
--- a/QGLViewer/QGLViewer.pro
+++ b/QGLViewer/QGLViewer.pro
@@ -240,26 +240,14 @@ macx|darwin-g++ {
	FRAMEWORK_HEADERS.path = Headers
	QMAKE_BUNDLE_DATA += FRAMEWORK_HEADERS

-	DESTDIR = $${HOME_DIR}/Library/Frameworks/
-
-	# For a Framework, 'include' and 'lib' do no make sense.
-	# These and prefix will all define the DESTDIR, in that order in case several are defined
-	!isEmpty( INCLUDE_DIR ) {
-	  DESTDIR = $${INCLUDE_DIR}
-	}
-
-	!isEmpty( LIB_DIR ) {
-	  DESTDIR = $${LIB_DIR}
-	}
-
-	!isEmpty( PREFIX ) {
-	  DESTDIR = $${PREFIX}
-	}
-
-	QMAKE_POST_LINK=cd $$DESTDIR/QGLViewer.framework/Headers && (test -L QGLViewer || ln -s . QGLViewer)
-
-	#QMAKE_LFLAGS_SONAME  = -Wl,-install_name,@executable_path/../Frameworks/
-	#QMAKE_LFLAGS_SONAME  = -Wl,-install_name,
+        !isEmpty( LIB_DIR ) {
+            DESTDIR = $${LIB_DIR}
+        }
+
+        # or to $${PREFIX}/lib otherwise
+        !isEmpty( PREFIX ) {
+            DESTDIR = $${PREFIX}/lib
+        }

	# Framework already installed, with includes
	INSTALLS -= include target
