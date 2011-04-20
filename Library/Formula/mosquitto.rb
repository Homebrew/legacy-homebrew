require 'formula'

class Mosquitto < Formula
  url 'http://mosquitto.org/files/source/mosquitto-0.9.3.tar.gz'
  homepage 'http://mosquitto.org'
  md5 'e40040533067a22be783af14d8f16a46'

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
end
