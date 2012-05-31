require 'formula'

class Qhull < Formula
  homepage 'http://www.qhull.org/'
  url 'http://www.qhull.org/download/qhull-2011.1-src.tgz'
  md5 'a65061cf2a6e6581182f4df0f3667a8e'

  depends_on 'cmake' => :build

  def patches
    # Patch from MacPorts that makes a couple of cosmetic edits to CMakeLists.txt:
    #
    #  * The testing programs user_eg, user_eg2 and user_eg3 are no longer
    #    built and installed.
    #
    #  * The VERSION property is no longer set on the command line tools.
    #    Setting this property causes CMake to install `binname-version` along
    #    with a symlink `binname` that points to `binname-version`. This is
    #    pointless for something that is managed by a package manager.
    {:p0 => 'https://trac.macports.org/export/83287/trunk/dports/math/qhull/files/patch-CMakeLists.txt.diff'}
  end

  def install
    system "cmake", ".", "-DMAN_INSTALL_DIR=#{man1}", *std_cmake_args
    system "make install"
  end
end
