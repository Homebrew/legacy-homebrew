require 'formula'

class Opencv <Formula
  # Use head, don't install 2.1.0 due to a *massive* memory leak:
  # https://code.ros.org/trac/opencv/ticket/253
  head 'https://code.ros.org/svn/opencv/trunk/opencv', :using => :svn
  homepage 'http://opencv.willowgarage.com/wiki/'

  depends_on 'cmake'
  depends_on 'pkg-config'

  depends_on 'libtiff' => :optional
  depends_on 'jasper'  => :optional
  depends_on 'tbb'     => :optional

  # Can also depend on ffmpeg, but this pulls in a lot of extra stuff that you don't
  # need unless you're doing video analysis, and some of it isn't in Homebrew anyway.
  # depends_on 'ffmpeg'

  def install
    system "cmake -G 'Unix Makefiles' -DCMAKE_INSTALL_PREFIX:PATH=#{prefix} ."
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
