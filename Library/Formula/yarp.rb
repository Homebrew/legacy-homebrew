require 'formula'

class Yarp < Formula
  url 'http://downloads.sourceforge.net/yarp0/yarp-2.3.4.tar.gz'
  md5 '00a2b21ab6e6469bfc99fedf00a74c0f'
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
