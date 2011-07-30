require 'formula'

class Opencv < Formula
  url 'http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/2.3/OpenCV-2.3.0.tar.bz2'
  version "2.3"
  homepage 'http://opencv.willowgarage.com/wiki/'
  md5 'dea5e9df241ac37f4439da16559e420d'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build

  depends_on 'libtiff' => :optional
  depends_on 'jasper'  => :optional
  depends_on 'jpeg'  => :optional
  depends_on 'qt'  => :optional

  def options
    [
        ['--build32','Force a 32-bit build.'],
        ['--tbb','Enable Threaded Building Blocks'],
        ['--ffmpeg','Enable FFMPEG'],
    ]
  end

  depends_on "ffmpeg" if ARGV.include? '--ffmpeg'
  depends_on "python" if ARGV.include? '--python'
  depends_on "tbb" if ARGV.include? '--tbb'

  def install
    makefiles = "cmake -G 'Unix Makefiles' -DCMAKE_INSTALL_PREFIX:PATH=#{prefix} -DENABLE_SSE3=ON ."
    makefiles += " -DOPENCV_EXTRA_C_FLAGS='-arch i386 -m32'" if ARGV.include? '--build32'
    makefiles += " -DWITH_TBB=ON" if ARGV.include? '--tbb'
    makefiles += " -DWITH_FFMPEG=ON" if ARGV.include? '--ffmpeg'
    system makefiles
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    The OpenCV Python module will not work until you edit your PYTHONPATH like so:
      export PYTHONPATH="#{HOMEBREW_PREFIX}/lib/python2.6/site-packages/:$PYTHONPATH"

    To make this permanent, put it in your shell's profile (e.g. ~/.profile).
    EOS
  end
end
