require 'formula'

class Mosquitto < Formula
  url 'http://mosquitto.org/files/source/mosquitto-0.12.tar.gz'
  homepage 'http://mosquitto.org/'
  md5 'e21ecb18dc8f9c3103fab95bbf8cffc7'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
