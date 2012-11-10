require 'formula'

class Yarp < Formula
  homepage 'http://yarp.it'
  url 'http://downloads.sourceforge.net/yarp0/yarp-2.3.19.tar.gz'
  sha1 'be2954a7ef7b1cb0bbb2ec1ac07371b5847a9ce6'

  head 'https://yarp0.svn.sourceforge.net/svnroot/yarp0/trunk/yarp2'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on 'ace'
  depends_on 'gsl'
  depends_on 'gtk+'
  depends_on 'gtkmm'
  depends_on 'libglademm'
  depends_on 'sqlite'
  depends_on 'gnu-readline'
  depends_on 'jpeg'
  depends_on :x11

  def install
    args = std_cmake_args + %W[
      -DCREATE_LIB_MATH=TRUE
      -DCREATE_GUIS=TRUE
      -DCREATE_YMANAGER=TRUE
      -DYARP_USE_SYSTEM_SQLITE=TRUE
      -DCREATE_OPTIONAL_CARRIERS=TRUE
      -DENABLE_yarpcar_mjpeg_carrier=TRUE
      -DENABLE_yarpcar_rossrv_carrier=TRUE
      -DENABLE_yarpcar_tcpros_carrier=TRUE
      -DENABLE_yarpcar_xmlrpc_carrier=TRUE
      -DENABLE_yarpcar_bayer_carrier=TRUE
      -DUSE_LIBDC1394=FALSE
      -DENABLE_yarpcar_priority_carrier=TRUE
      -DCREATE_IDLS=TRUE
      -DENABLE_yarpidl_thrift=TRUE
      .]

    system "cmake", *args
    system "make install"
  end
end
