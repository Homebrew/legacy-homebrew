require 'formula'

class JsonSpirit < Formula
  homepage 'http://www.codeproject.com/KB/recipes/JSON_Spirit.aspx'
  url 'https://github.com/png85/json_spirit/archive/json_spirit-4.07.tar.gz'
  sha1 'b29272c59f8f840c255f75a0949ba839b7cec13b'

  depends_on 'boost'
  depends_on 'cmake' => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_STATIC_LIBRARIES=ON"

    system "cmake", *args
    system "make"

    args = std_cmake_args
    args << "-DBUILD_STATIC_LIBRARIES=OFF"
    system "cmake", *args
    system "make install"
  end
end
