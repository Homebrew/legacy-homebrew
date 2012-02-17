require 'formula'

class Mosquitto < Formula
  url 'http://mosquitto.org/files/source/mosquitto-0.14.4.tar.gz'
  homepage 'http://mosquitto.org/'
  md5 '88750338c2096671c01cf7e461d5c06d'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    system "mosquitto -h > /dev/null ; [ $? -eq 3 ]"
  end
end
