require 'formula'

class Opencv <Formula
  url 'http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/2.2/OpenCV-2.2.0.tar.bz2'
  version "2.2"
  homepage 'http://opencv.willowgarage.com/wiki/'
  md5 '122c9ac793a46854ef2819fedbbd6b1b'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build

  depends_on 'libtiff' => :optional
  depends_on 'jasper'  => :optional
  depends_on 'tbb'     => :optional

  # Can also depend on ffmpeg, but this pulls in a lot of extra stuff that
  # you don't need unless you're doing video analysis, and some of it isn't
  # in Homebrew anyway.

  def options
    [['--build32', 'Force a 32-bit build.']]
  end

  def install
    makefiles = "cmake -G 'Unix Makefiles' -DCMAKE_INSTALL_PREFIX:PATH=#{prefix} ."
    makefiles += " -DOPENCV_EXTRA_C_FLAGS='-arch i386 -m32'" if ARGV.include? '--build32'
    system makefiles
    system "make"
    system "make install"
  end

  def patches
      # fixes bug 731, link against highgui fails
      DATA
  end

  def caveats; <<-EOS.undent
    The OpenCV Python module will not work until you edit your PYTHONPATH like so:
      export PYTHONPATH="#{HOMEBREW_PREFIX}/lib/python2.6/site-packages/:$PYTHONPATH"

    To make this permanent, put it in your shell's profile (e.g. ~/.profile).
    EOS
  end
end


__END__
diff --git a/modules/highgui/src/cap.cpp b/modules/highgui/src/cap.cpp
index 63e9052..6c2b082 100644
--- a/modules/highgui/src/cap.cpp
+++ b/modules/highgui/src/cap.cpp
@@ -52,10 +52,10 @@
 namespace cv
 {
 
-template<> inline void Ptr<CvCapture>::delete_obj()
+template<> void Ptr<CvCapture>::delete_obj()
 { cvReleaseCapture(&obj); }
 
-template<> inline void Ptr<CvVideoWriter>::delete_obj()
+template<> void Ptr<CvVideoWriter>::delete_obj()
 { cvReleaseVideoWriter(&obj); }
 
 }
