require 'formula'

class Libqglviewer < Formula
  homepage 'http://www.libqglviewer.com/'
  url 'http://www.libqglviewer.com/src/libQGLViewer-2.4.0.tar.gz'
  sha1 '91e3c889822909dc3684e1be6d7f9ff734cc8047'

  head 'https://github.com/GillesDebunne/libQGLViewer.git'

  option :universal

  depends_on 'qt'

  def patches; DATA; end

  def install
    args = ["PREFIX=#{prefix}"]
    args << "CONFIG += x86 x86_64" if build.universal?

    cd 'QGLViewer' do
      system "qmake", *args
      system "make"
    end
  end

  def caveats; <<-EOS.undent
    To avoid issues with runtime linking and facilitate usage of the library:
      sudo ln -s "#{prefix}/QGLViewer.framework" "/Library/Frameworks/QGLViewer.framework"
    EOS
  end
end

__END__
--- a/QGLViewer/QGLViewer.pro
+++ b/QGLViewer/QGLViewer.pro
@@ -250,7 +250,7 @@
     FRAMEWORK_HEADERS.path = Headers
     QMAKE_BUNDLE_DATA += FRAMEWORK_HEADERS

-    DESTDIR = $${HOME_DIR}/Library/Frameworks/
+    DESTDIR = $${PREFIX}

     QMAKE_POST_LINK=cd $$DESTDIR/QGLViewer.framework/Headers && ln -s . QGLViewer
