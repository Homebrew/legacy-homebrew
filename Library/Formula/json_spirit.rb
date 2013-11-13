require 'formula'

class JsonSpirit < Formula
  homepage 'http://www.codeproject.com/KB/recipes/JSON_Spirit.aspx'
  url 'https://github.com/png85/json_spirit/archive/json_spirit-4.07.zip'
  sha1 'e7055cb8fd596fc89b73e6898d8162a56fd80ec7'

  depends_on 'boost'
  depends_on 'cmake' => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_STATIC_LIBRARIES=ON"

    system "cmake", *args
    system "make install"
  end
end
