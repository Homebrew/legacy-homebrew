require 'formula'

class Mosquitto <Formula
  url 'http://mosquitto.org/files/source/mosquitto-0.9.1.tar.gz'
  homepage 'http://mosquitto.org'
  md5 '8923b814441aa2c0646203920dcf3e1b'

  depends_on 'cmake'
  depends_on 'sqlite'

  def install
    ENV.deparallelize
    ENV.no_optimization
    system "cmake . #{std_cmake_parameters}"
    system "make"
    system "make install"
  end
end
