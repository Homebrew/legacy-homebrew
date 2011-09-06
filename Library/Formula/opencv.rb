require 'formula'

class Opencv < Formula
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
    # fixes for newer ffmpeg builds; cf https://code.ros.org/trac/opencv/ticket/1020
    # "/modules/highgui/src/cap_ffmpeg.cpp:469: error: ‘CODEC_TYPE_VIDEO’ was not declared in this scope" etc
    # and
    # "/modules/highgui/src/cap_ffmpeg.cpp:821: error: 'AVERROR_NUMEXPECTED' was not declared in this scope" etc
    { :p4 => ["https://code.ros.org/trac/opencv/raw-attachment/ticket/1020/ffmpeg_build.patch", "https://code.ros.org/trac/opencv/raw-attachment/ticket/1020/ffmpeg_build_2.patch" ] }
  end
  
  def caveats; <<-EOS.undent
    The OpenCV Python module will not work until you edit your PYTHONPATH like so:
      export PYTHONPATH="#{HOMEBREW_PREFIX}/lib/python2.6/site-packages/:$PYTHONPATH"

    To make this permanent, put it in your shell's profile (e.g. ~/.profile).
    EOS
  end
end
