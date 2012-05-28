require 'formula'

class Mosquitto < Formula
  homepage 'http://mosquitto.org/'
  url 'http://mosquitto.org/files/source/mosquitto-0.15.tar.gz'
  md5 '7ae0ac38f1f379578ab5530e5dc7269e'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  def test
    system "#{bin}/mosquitto -h > /dev/null ; [ $? -eq 3 ]"
  end
end
