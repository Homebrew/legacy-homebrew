require 'formula'

class Opencv <Formula
  # Use head, don't install 2.1.0 due to a *massive* memory leak:
  # https://code.ros.org/trac/opencv/ticket/253
  head 'https://code.ros.org/svn/opencv/trunk/opencv', :using => :svn
  homepage 'http://opencv.willowgarage.com/wiki/'
  md5 ''

  depends_on 'cmake'
  depends_on 'pkg-config'

  # Optional.
  depends_on 'libtiff'
  depends_on 'jasper'
  depends_on 'tbb'

  # Very Optional? Pulls in lots of dependencies but maybe not needed unless you're doing video analysis
  # Video analysis requires a bunch more things which we don't have: libgstreamer, libxine, unicap, libdc1394 2.x (or libdc1394 1.x + libraw1394).
  # We can leave this disabled for now.
  # Maybe we could add a flag?
  #depends_on 'ffmpeg'

  # There are other optional dependencies but they don't currently exist in Homebrew.

  def install
    system "cmake -G 'Unix Makefiles' -DCMAKE_INSTALL_PREFIX:PATH=#{prefix} ."
    system "make"
    system "make install"
  end

    def caveats
      return <<-EOS
  The OpenCV Python module will not work until you edit your PYTHONPATH like so:

    export PYTHONPATH="#{HOMEBREW_PREFIX}/lib/python2.6/site-packages/:$PYTHONPATH"

  To make this permanent, put it in your shell's profile (e.g. ~/.profile).
    EOS
  end
end
