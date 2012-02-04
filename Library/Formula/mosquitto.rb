require 'formula'

class Mosquitto < Formula
  url 'http://mosquitto.org/files/source/mosquitto-0.14.4.tar.gz'
  homepage 'http://mosquitto.org/'
  md5 '88750338c2096671c01cf7e461d5c06d'

  depends_on 'cmake' => :build

  def patches
    # Fixes man page installation: in man/CMakeLists.txt,
    # the parentheses around MANDEST should be braces.
    { :p1 => "https://bitbucket.org/oojah/mosquitto/changeset/fc5c83daefb0/raw/mosquitto-fc5c83daefb0.diff" }
  end

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    system "mosquitto -h > /dev/null ; [ $? -eq 3 ]"
  end
end
