require 'formula'

class Mosquitto <Formula
  url 'http://mosquitto.org/files/source/mosquitto-0.9.1.tar.gz'
  homepage 'http://mosquitto.org'
  md5 '8923b814441aa2c0646203920dcf3e1b'

  depends_on 'cmake'

  def patches
   {:p1 => 'http://gist.github.com/raw/783895/13851510fe7d002ef805bcefa79a7569e2eef84e/mosquitto-cmake-man-and-python-patch.patch' }
  end

  def install
    ENV.deparallelize
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
