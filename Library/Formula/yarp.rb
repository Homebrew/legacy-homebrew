require 'formula'

class Yarp < Formula
  homepage 'http://yarp.it'
  url 'http://downloads.sourceforge.net/yarp0/yarp-2.3.15.tar.gz'
  md5 '58912d7d1a6ed3347fc15ef7236899e1'

  head 'https://yarp0.svn.sourceforge.net/svnroot/yarp0/trunk/yarp2'

  depends_on 'cmake' => :build
  depends_on 'ace'
  depends_on 'gsl'
  depends_on 'gtk+'
  depends_on 'sqlite'
  depends_on 'readline'
  depends_on 'jpeg'

  def install
    args = std_cmake_parameters.split + %W[
      -DCREATE_LIB_MATH=TRUE
      -DCREATE_GUIS=TRUE
      -DCREATE_YMANAGER=TRUE
      -DYARP_USE_SYSTEM_SQLITE=TRUE
      -DCREATE_OPTIONAL_CARRIERS=TRUE
      -DENABLE_yarpcar_mjpeg_carrier=TRUE
      -DENABLE_yarpcar_rossrv_carrier=TRUE
      -DENABLE_yarpcar_tcpros_carrier=TRUE
      -DENABLE_yarpcar_xmlrpc_carrier=TRUE
      .]

    system "cmake", *args
    system "make install"
  end
end
