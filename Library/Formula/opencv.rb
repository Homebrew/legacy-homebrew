require 'formula'

class Opencv <Formula
  # use 2.2.1-pre since some critical bugs are fixed:
  # https://code.ros.org/trac/opencv/log/branches/2.2/opencv
  url 'https://code.ros.org/svn/opencv/branches/2.2/opencv', :using => :svn, :revision => '5226'
  version "2.2.1-svn4437"
  homepage 'http://opencv.willowgarage.com/wiki/'

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

  def caveats; <<-EOS.undent
    The OpenCV Python module will not work until you edit your PYTHONPATH like so:
      export PYTHONPATH="#{HOMEBREW_PREFIX}/lib/python2.6/site-packages/:$PYTHONPATH"

    To make this permanent, put it in your shell's profile (e.g. ~/.profile).
    EOS
  end
end
