require 'formula'

class Yarp < Formula
  url 'http://downloads.sourceforge.net/yarp0/yarp-2.3.14.tar.gz'
  md5 '4ee659e31abe915e3453062f994aabd7'
  homepage 'http://yarp.it'
  head 'https://yarp0.svn.sourceforge.net/svnroot/yarp0/trunk/yarp2'

  depends_on 'cmake' => :build

  depends_on 'ace'
  depends_on 'gsl'
  depends_on 'gtk+'
  depends_on 'sqlite'
  depends_on 'readline'

  def install
    system "cmake . #{std_cmake_parameters} -DCREATE_LIB_MATH=TRUE -DCREATE_GUIS=TRUE -DCREATE_YMANAGER=TRUE -DYARP_USE_SYSTEM_SQLITE=TRUE"
    system "make install"
  end
end
