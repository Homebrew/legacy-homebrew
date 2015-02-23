require 'formula'

class Libqglviewer < Formula
  homepage 'http://www.libqglviewer.com/'
  url 'http://www.libqglviewer.com/src/libQGLViewer-2.6.1.tar.gz'
  sha1 '9220b3f2b8629df36bf91cc8de397e65b2cab476'

  head 'https://github.com/GillesDebunne/libQGLViewer.git'

  bottle do
    cellar :any
    revision 1
    sha1 "9fa813e1c6af88267a9d76ef9bcd6bcf778c6fb5" => :yosemite
    sha1 "65093ea7674244be57591ec6ad5ee692c47573cd" => :mavericks
    sha1 "2e472e6ff337837cc9fd9d61e4c4fd5856e28589" => :mountain_lion
  end

  option :universal

  depends_on 'qt'

  # This patches makes the package install QGLViewer.framework under
  # #{lib}, where it will be picked by homebrew.
  # Patch has been submitted to the developer, check with versions
  # newer than 2.6.1 if this is still required.
  patch :DATA

  def install
    args = ["PREFIX=#{prefix}"]
    args << "CONFIG += x86 x86_64" if build.universal?

    cd 'QGLViewer' do
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
