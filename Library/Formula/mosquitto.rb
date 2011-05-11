require 'formula'

class Mosquitto < Formula
  url 'http://mosquitto.org/files/source/mosquitto-0.10.tar.gz'
  homepage 'http://mosquitto.org'
  md5 'a0fc18f41684627ec54fc60bdd8fe9c7'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
