require 'formula'

class Libqglviewer < Formula
  homepage 'http://www.libqglviewer.com/'
  url 'http://www.libqglviewer.com/src/libQGLViewer-2.3.17.tar.gz'
  sha1 '03b1da73bdb07988184c1f5d7c1c360be27b2a0e'

  depends_on 'qt'

  def options
    [
      ['--universal', "Build both x86_64 and x86 architectures."],
    ]
  end

  def patches
    DATA
  end

  def install
    args = ["PREFIX=#{prefix}"]

    if ARGV.include? '--universal'
      args << "CONFIG += x86 x86_64"
    end

    cd 'QGLViewer' do
      system "qmake", *args
      system "make"
    end
  end

  def caveats
     <<-EOS.undent
      To avoid issues with runtime linking and facilitate usage of the library:
        sudo ln -s "#{prefix}/QGLViewer.framework" "/Library/Frameworks/QGLViewer.framework"
    EOS
  end
end

__END__
--- a/QGLViewer/QGLViewer.pro
+++ b/QGLViewer/QGLViewer.pro
@@ -246,7 +246,7 @@
     FRAMEWORK_HEADERS.path = Headers
     QMAKE_BUNDLE_DATA += FRAMEWORK_HEADERS

-    DESTDIR = ~/Library/Frameworks/
+    DESTDIR = $${PREFIX}

     QMAKE_POST_LINK=cd $$DESTDIR/QGLViewer.framework/Headers && ln -s . QGLViewer
