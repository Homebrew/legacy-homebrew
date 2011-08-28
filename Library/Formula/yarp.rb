require 'formula'

class Yarp < Formula
  url 'http://downloads.sourceforge.net/yarp0/yarp-2.3.8.tar.gz'
  md5 '5a932488be65aa4318f5c7f4aaf9ff50'
  homepage 'http://yarp.it'
  head 'https://yarp0.svn.sourceforge.net/svnroot/yarp0/trunk/yarp2'

  depends_on 'cmake' => :build

  depends_on 'ace'
  depends_on 'gsl'
  depends_on 'gtk+'

  def install
    system "cmake . #{std_cmake_parameters} -DCREATE_LIB_MATH=TRUE -DCREATE_GUIS=TRUE -DCREATE_YARPSERVER3=TRUE"
    system "make install"
  end
end
