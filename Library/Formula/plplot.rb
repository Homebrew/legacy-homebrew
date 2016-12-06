require 'formula'

class Plplot < Formula
  url 'http://sourceforge.net/projects/plplot/files/plplot/5.9.8%20Source/plplot-5.9.8.tar.gz'
  homepage 'http://plplot.sourceforge.net'
  md5 'af6393ca615f1f3aa4de4522122736eb'

  depends_on 'cmake'
  depends_on 'pkg-config'
  depends_on 'pango'

  def install
    system "mv ChangeLog.release ChangeLog" # this seems to be a packaging error in 5.9.8; make install looks for a ChangeLog file but there isn't one in the .tar.gz. This has been reported upstream -- see https://sourceforge.net/tracker/?func=detail&aid=3383853&group_id=2915&atid=102915
    system "mkdir plplot-build"
    Dir.chdir "plplot-build"
    system "cmake #{std_cmake_parameters} .."
    system "make"
    system "make install"
  end
end
