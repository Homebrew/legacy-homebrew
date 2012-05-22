require 'formula'

class Mosquitto < Formula
  homepage 'http://mosquitto.org/'
  url 'http://mosquitto.org/files/source/mosquitto-0.14.4.tar.gz'
  md5 '88750338c2096671c01cf7e461d5c06d'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  def test
    system "#{bin}/mosquitto -h > /dev/null ; [ $? -eq 3 ]"
  end
end
