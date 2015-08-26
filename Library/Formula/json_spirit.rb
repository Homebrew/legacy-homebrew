class JsonSpirit < Formula
  desc "C++ JSON parser/generator"
  homepage "http://www.codeproject.com/KB/recipes/JSON_Spirit.aspx"
  url "https://github.com/png85/json_spirit/archive/json_spirit-4.07.tar.gz"
  sha256 "3d53fac906261de1cf48db362436ca32b96547806ab6cce5ac195460ad732320"

  depends_on "boost"
  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_STATIC_LIBRARIES=ON"

    system "cmake", *args
    system "make"

    args = std_cmake_args
    args << "-DBUILD_STATIC_LIBRARIES=OFF"
    system "cmake", *args
    system "make", "install"
  end
end
