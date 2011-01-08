require 'formula'

class Mosquitto <Formula
  url 'http://mosquitto.org/files/source/mosquitto-0.9.1.tar.gz'
  homepage 'http://mosquitto.org'
  md5 '8923b814441aa2c0646203920dcf3e1b'

  depends_on 'cmake'

  def patches
    {:p1 => 'https://gist.github.com/raw/771217/f946d3e4c7326066f36c0411287a0f8a1e820a00/mosquitto-cmake-man.patch' }
  end

  def install
    ENV.deparallelize
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
